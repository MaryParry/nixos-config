return {
  "IogaMaster/neocord",
  event = "VeryLazy",
  opts = {
    logo = "auto",
    logo_tooltip = "Neovim",
    main_image = "language",
    log_level = nil,
    debounce_timeout = 5,
    blacklist = {},
    file_assets = {},
    show_time = true,
    global_timer = false,
    auto_update = true,

    -- Rich Presence text options
    editing_text = "Editing %s",
    file_explorer_text = "Browsing %s",
    git_commit_text = "Committing changes",
    plugin_manager_text = "Managing plugins",
    reading_text = "Reading %s",
    workspace_text = "Working on %s",
    line_number_text = "Line %s out of %s",
    terminal_text = "Using Terminal",
  },
  config = function(_, opts)
    -- 1. Fix get_gui_info crash in terminal/headless (chan.client is nil)
    local ok_utils, utils = pcall(require, "neocord.utils")
    if ok_utils then
      utils.get_gui_info = function()
        local ok_chan, chan = pcall(vim.api.nvim_get_chan_info, 1)
        if ok_chan and chan and chan.client and chan.client.type == "ui" then
          return chan.client.name
        end
        return nil
      end
    end

    local neocord = require("neocord")

    -- 2. Dynamic multi-socket scanner (discord-ipc-0 to discord-ipc-9 across runtime dirs)
    local function find_discord_socket()
      local uid = (vim.loop.getuid and vim.loop.getuid()) or 1000
      local dirs = {
        os.getenv("XDG_RUNTIME_DIR"),
        "/run/user/" .. uid,
        os.getenv("TMPDIR"),
        "/tmp",
      }
      for _, dir in ipairs(dirs) do
        if dir and vim.fn.isdirectory(dir) == 1 then
          for i = 0, 9 do
            local sock = dir:gsub("/+$", "") .. "/discord-ipc-" .. i
            if vim.loop.fs_stat(sock) then
              return sock
            end
          end
        end
      end
      return (os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. uid)) .. "/discord-ipc-0"
    end

    neocord.get_discord_socket_path = function()
      return find_discord_socket()
    end

    -- 3. Auto-reconnect on pipe close / pipe error when Discord restarts
    local ok_discord, Discord = pcall(require, "lib.discord")
    if ok_discord then
      local orig_connect = Discord.connect
      Discord.connect = function(self, on_connect)
        local sock = find_discord_socket()
        if sock then
          self.ipc_socket = sock
        end
        if not self.pipe or self.pipe:is_closing() or not self.pipe:is_active() then
          self.pipe = vim.loop.new_pipe(false)
        end
        orig_connect(self, on_connect)
      end

      local orig_read = Discord.read_message
      Discord.read_message = function(self, nonce, on_response, err, chunk)
        if (not chunk and not err) or (err and type(err) == "string" and err:find("EPIPE")) then
          neocord.is_connected = false
          neocord.is_authorized = false
        end
        return orig_read(self, nonce, on_response, err, chunk)
      end
    end

    neocord.setup(opts)

    -- Initial update when buffer is ready
    vim.defer_fn(function()
      pcall(function() neocord:update() end)
    end, 800)
  end,
}
