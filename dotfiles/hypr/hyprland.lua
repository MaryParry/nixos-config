-- Hyprland Lua Config (Migrated from hyprland.conf)
-- Refer to https://wiki.hypr.land/ for details

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
})

-- hl.monitor({
--     output   = "HDMI-A-1",
--     mode     = "1920x1080@60",
--     position = "1920x0",
--     scale    = 1,
-- })

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
    mirror   = "eDP-1",
}) -- for tv screen

-- hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "vicinae toggle"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("dunst")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("noctalia-shell")
    hl.exec_cmd("bluetoothctl")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("bluetoothctl power on")
    -- hl.exec_cmd("hyprpm reload")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 1,
        gaps_out = 3,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(b0b0b0b0)", "rgba(c3dee0c3)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        blur = {
            enabled   = true,
            size      = 3,
            passes    = 2,
            vibrancy  = 0.0696,
        },
        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 4,
            color        = 0xee1a1a1a,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
    },

    input = {
        kb_layout    = "us,ge,de",
        kb_options   = "grp:alt_shift_toggle",
        follow_mouse = 1,
        sensitivity  = 0.2,
        touchpad = {
            natural_scroll = true,
        },
    },
})


--------------------
---- ANIMATIONS ----
--------------------

hl.curve("myBezier",          { type = "bezier", points = { {0.05, 0.9},   {0.1, 1.05}  } })
hl.curve("miniBounce",        { type = "bezier", points = { {-0.01, 0.81}, {0.01, 1.04} } })
hl.curve("md3_standard",      { type = "bezier", points = { {0.2, 0.0},    {0.0, 1.0}   } })
hl.curve("md3_decel",         { type = "bezier", points = { {0.05, 0.7},   {0.1, 1.0}   } })
hl.curve("md3_accel",         { type = "bezier", points = { {0.3, 0.0},    {0.8, 0.15}  } })
hl.curve("md2",               { type = "bezier", points = { {0.4, 0.0},    {0.2, 1.0}   } })
hl.curve("menu_decel",        { type = "bezier", points = { {0.1, 1.0},    {0.0, 1.0}   } })
hl.curve("menu_accel",        { type = "bezier", points = { {0.38, 0.04},  {1.0, 0.07}  } })
hl.curve("wind",              { type = "bezier", points = { {0.05, 0.9},   {0.1, 1.05}  } })
hl.curve("winIn",             { type = "bezier", points = { {0.1, 1.1},    {0.1, 1.1}   } })
hl.curve("winOut",            { type = "bezier", points = { {0.3, -0.3},   {0.0, 1.0}   } })
hl.curve("overshot",          { type = "bezier", points = { {0.13, 0.99},  {0.29, 1.08} } })
hl.curve("crazyshot",         { type = "bezier", points = { {0.1, 1.5},    {0.76, 0.92} } })
hl.curve("bounce",            { type = "bezier", points = { {0.4, 0.9},    {0.6, 1.0}   } })
hl.curve("snappyReturn",      { type = "bezier", points = { {0.4, 0.9},    {0.6, 1.0}   } })
hl.curve("OutBack",           { type = "bezier", points = { {0.34, 1.56},  {0.64, 1.0}  } })
hl.curve("fluent_decel",      { type = "bezier", points = { {0.0, 0.2},    {0.4, 1.0}   } })
hl.curve("easeOutCirc",       { type = "bezier", points = { {0.0, 0.55},   {0.45, 1.0}  } })
hl.curve("easeOutCubic",      { type = "bezier", points = { {0.33, 1.0},   {0.68, 1.0}  } })
hl.curve("easeOutExpo",       { type = "bezier", points = { {0.16, 1.0},   {0.3, 1.0}   } })
hl.curve("easeInOutCirc",     { type = "bezier", points = { {0.85, 0.0},   {0.15, 1.0}  } })
hl.curve("easeinoutsine",     { type = "bezier", points = { {0.37, 0.0},   {0.63, 1.0}  } })
hl.curve("smoothOut",         { type = "bezier", points = { {0.5, 0.0},    {0.99, 0.99} } })
hl.curve("smoothIn",          { type = "bezier", points = { {0.5, -0.5},   {0.68, 1.5}  } })
hl.curve("quart",             { type = "bezier", points = { {0.25, 1.0},   {0.5, 1.0}   } })
hl.curve("hyprnostretch",     { type = "bezier", points = { {0.05, 0.9},   {0.1, 1.0}   } })
hl.curve("slideInFromRight",  { type = "bezier", points = { {0.5, 0.0},    {0.5, 1.0}   } })
hl.curve("liner",             { type = "bezier", points = { {1.0, 1.0},    {1.0, 1.0}   } })
hl.curve("linear",            { type = "bezier", points = { {0.0, 0.0},    {1.0, 1.0}   } })

hl.animation({ leaf = "windows",    enabled = true, speed = 7, bezier = "menu_decel" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "menu_decel" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "menu_decel" })
hl.animation({ leaf = "borderangle",enabled = true, speed = 8, bezier = "menu_decel" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7, bezier = "menu_decel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "menu_decel" })


------------------
---- GESTURES ----
------------------

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


----------------------
---- KEYBINDINGS ----
----------------------

local mainMod = "SUPER"

hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M", hl.dsp.exec_raw("movetoworkspacesilent special:minimized"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))

-- Move focus with mainMod + arrow keys / hjkl
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "d" }))

-- Move active window with mainMod + SHIFT + arrow keys / hjkl
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + h",     hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + l",     hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + k",     hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + j",     hl.dsp.window.move({ direction = "d" }))

-- Resize windows
hl.bind(mainMod .. " + R",         hl.dsp.window.resize({ x = 30, y = 0, relative = true }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })

-- Switch workspaces & move window to workspace with mainMod + [0-9]
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",    hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_right", hl.dsp.focus({ workspace = "e+1" }))

-- Audio control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })

-- Screen brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s +5%"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"),  { locked = true })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Lock on lid close / mod+L
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })
hl.bind(mainMod .. " + L",       hl.dsp.exec_cmd("loginctl lock-session"))


----------------------
---- WINDOW RULES ----
----------------------

hl.window_rule({
    name  = "windowrule-jb-tag",
    match = { class = "^jetbrains-.*", initial_title = "" },
    tag   = "+jb",
})

hl.window_rule({
    name  = "windowrule-jb-focus",
    match = { tag = "jb" },
    focus_on_activate = true,
    no_initial_focus  = true,
    float = false,
})

hl.window_rule({
    name  = "disable-blur-global",
    match = { class = ".*" },
    no_blur = true,
})

hl.window_rule({
    name  = "kitty-transparency",
    match = { class = "^(kitty)$" },
    opacity = "0.85 0.75",
    no_blur = false,
})


-------------------------
---- PLUGINS (HYPRSPACE) ----
-------------------------

hl.plugin.load("/etc/profiles/per-user/saponela/lib/libhyprspace.so")

-- Toggle workspace overview with Super + Tab
hl.bind(mainMod .. " + Tab", hl.dsp.exec_raw("overview:toggle"))


-----------------------------
---- NOCTALIA COLOR PARSER ----
-----------------------------

local function load_noctalia_colors()
    local path = os.getenv("HOME") .. "/.config/hypr/noctalia/noctalia-colors.conf"
    local file = io.open(path, "r")
    if not file then return end
    
    local vars = {}
    for line in file:lines() do
        local var, val = line:match("^%$([%w_]+)%s*=%s*rgb%((%x+)%)")
        if var and val then
            vars[var] = "rgba(" .. val .. "ff)"
        end
    end
    file:close()
    
    if vars.primary then
        hl.config({
            general = {
                col = {
                    active_border   = vars.primary,
                    inactive_border = vars.surface or "rgba(595959aa)",
                },
            },
            group = {
                col = {
                    border_active           = vars.secondary,
                    border_inactive         = vars.surface,
                    border_locked_active   = vars.error,
                    border_locked_inactive = vars.surface,
                },
                groupbar = {
                    col = {
                        active          = vars.secondary,
                        inactive        = vars.surface,
                        locked_active   = vars.error,
                        locked_inactive = vars.surface,
                    }
                }
            }
        })
    end
end

load_noctalia_colors()
