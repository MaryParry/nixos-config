#!/usr/bin/env node
const net = require('net');
const fs = require('fs');
const path = require('path');

const runtimeDir = process.env.XDG_RUNTIME_DIR || `/run/user/${process.getuid()}`;
const hyprDir = path.join(runtimeDir, 'hypr');

let realSig = process.env.HYPRLAND_INSTANCE_SIGNATURE;
if (!realSig || realSig === 'waybar-proxy') {
  try {
    const dirs = fs.readdirSync(hyprDir).filter(d => d !== 'waybar-proxy' && fs.existsSync(path.join(hyprDir, d, '.socket.sock')));
    if (dirs.length > 0) {
      realSig = dirs[0];
    }
  } catch (e) {}
}

if (!realSig) {
  console.error("Could not find active Hyprland instance signature");
  process.exit(1);
}

const realDir = path.join(hyprDir, realSig);
const realSock = path.join(realDir, '.socket.sock');
const realSock2 = path.join(realDir, '.socket2.sock');

const proxyDir = path.join(hyprDir, 'waybar-proxy');
const proxySock = path.join(proxyDir, '.socket.sock');
const proxySock2 = path.join(proxyDir, '.socket2.sock');

if (!fs.existsSync(proxyDir)) fs.mkdirSync(proxyDir, { recursive: true });

// Symlink .socket2.sock directly so all event subscriptions are 100% direct and instant
try {
  if (fs.existsSync(proxySock2)) fs.unlinkSync(proxySock2);
  fs.symlinkSync(realSock2, proxySock2);
} catch (e) {
  console.error("Failed to symlink socket2:", e);
}

// Clean up old socket if present
if (fs.existsSync(proxySock)) {
  try { fs.unlinkSync(proxySock); } catch (e) {}
}

const server = net.createServer((client) => {
  const upstream = net.connect(realSock);

  client.on('data', (chunk) => {
    let str = chunk.toString();
    const m = str.match(/^(\/)?dispatch\s+(?:focusworkspaceoncurrentmonitor\s+|workspace\s+)?(\d+|name:\S+)/);
    if (m) {
      const ws = m[2];
      const target = ws.startsWith('name:') ? JSON.stringify(ws.slice(5)) : ws;
      str = `dispatch hl.dsp.focus({ workspace = ${target} })\n`;
      chunk = Buffer.from(str);
    }
    upstream.write(chunk);
  });

  upstream.on('data', (chunk) => {
    client.write(chunk);
  });

  client.on('error', () => upstream.destroy());
  upstream.on('error', () => client.destroy());
  client.on('close', () => upstream.end());
  upstream.on('close', () => client.end());
});

server.listen(proxySock, () => {
  console.log('Waybar Hyprland IPC Proxy ready on', proxySock, 'forwarding to', realSig);
});

const cleanup = () => {
  try { if (fs.existsSync(proxySock)) fs.unlinkSync(proxySock); } catch (e) {}
  process.exit();
};
process.on('SIGINT', cleanup);
process.on('SIGTERM', cleanup);
process.on('exit', cleanup);
