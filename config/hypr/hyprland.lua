-- ################
-- ### MONITORS ###
-- ################

-- hl.monitor({ output = "HDMI-A-1", mode = "1920x1080", position = "3440x0", scale = "1" })
hl.monitor({
    output = "DP-3",
    mode = "3440x1440@75",
    position = "0x0",
    scale = "auto",
    bitdepth = 10,
--    cm = "hdr",
    supports_hdr = 1,
    sdr_eotf = "gamma22",
    sdrbrightness = 1.0,     -- Убрали дикий множитель, вернули в норму
    sdrsaturation = 1.0,
    sdr_min_luminance = 0, -- Оставляем строгий ноль для глубокого черного
    sdr_max_luminance = 500, -- Адекватный белый для обычных SDR окон (можно 250)
    min_luminance = 0,     -- Защита от мусора из прошивки
    max_luminance = 1000
})


-- ###################
-- ### MY PROGRAMS ###
-- ###################

local terminal    = "kitty"
local fileManager = "yazi"
local menu        = "rofi -show drun"

-- #################
-- ### AUTOSTART ###
-- #################

hl.on("hyprland.start", function () 
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    -- Managed by systemd user service (obs-replay-buffer) with clean shutdown ordering:
    -- hl.exec_cmd("obs --startreplaybuffer --minimize-to-tray")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 21")
    hl.exec_cmd("Throne")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-- #############################
-- ### ENVIRONMENT VARIABLES ###
-- #############################

hl.env("XCURSOR_SIZE", "21")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("DEFAULT_TARGET_DIR", "/tmp")
hl.env("XDG_SCREENSHOTS_DIR", "/tmp")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "Fusion")

-- ###################
-- ### PERMISSIONS ###
-- ###################

-- See https://wiki.hypr.land/Configuring/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({ ecosystem = { enforce_permissions = 1 } })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-- #####################
-- ### LOOK AND FEEL ###
-- #####################

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = { top = 8, right = 12, bottom = 12, left = 12 },

        border_size = 2,

        -- https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
        col = {
            active_border = { colors = {"rgba(8c909eee)", "rgba(656977ee)"}, angle = 45 },
            inactive_border = "rgba(44485544)",
        },

        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 14,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity = 1,
        inactive_opacity = 1,

        shadow = {
            enabled = false,
        },

        -- https://wiki.hypr.land/Configuring/Variables/#blur
        blur = {
            enabled = false,
            size = 5,
            passes = 3,
            noise = 0.02,
            contrast = 1.0,
            brightness = 0.9,
            vibrancy = 0.3,
        },
    },

    animations = {
        enabled = true, -- yes, please :)
    },
})

-- Default animations, see https://wiki.hypr.land/Configuring/Animations/ for more

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0}  } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

hl.config({
    dwindle = {
        -- pseudotile = true -- Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true, -- You probably want this
    },

    cursor = {
        enable_hyprcursor = false,
    },

    misc = {
        force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    },


-- #############
-- ### INPUT ###
-- #############

    input = {
        kb_layout = "us,ru",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:ctrl_space_toggle",
        kb_rules = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})


-- ###################
-- ### KEYBINDINGS ###
-- ###################

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Grimblast Screenshots
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("grimblast --notify copy area"))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("grimblast --notify copy output"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("grimblast --notify copy active"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("DEFAULT_TARGET_DIR=/tmp grimblast --notify copysave area"))
hl.bind(mainMod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd("DEFAULT_TARGET_DIR=/tmp grimblast --notify copysave output"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("DEFAULT_TARGET_DIR=/tmp grimblast --notify copysave active"))

-- Basic Programs
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("zen"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty sudo -E " .. fileManager))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/rofi/cliphist-menu.py"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + tab", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("rofi -show combi"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("kitty --class Wiremix -e wiremix"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("save-replay"))

-- Focus
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Workspaces
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move windows
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))

-- Move window between workspaces
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + F1", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + F1", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


-- ##############################
-- ### WINDOWS AND WORKSPACES ###
-- ##############################

hl.workspace_rule({ workspace = "1", monitor = "DP-3" })
hl.workspace_rule({ workspace = "2", monitor = "DP-3" })
hl.workspace_rule({ workspace = "3", monitor = "DP-3" })
hl.workspace_rule({ workspace = "4", monitor = "DP-3" })
hl.workspace_rule({ workspace = "5", monitor = "DP-3" })
hl.workspace_rule({ workspace = "6", monitor = "DP-3" })
hl.workspace_rule({ workspace = "7", monitor = "DP-3" })
hl.workspace_rule({ workspace = "10", monitor = "DP-3" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })

hl.window_rule({
     name = "suppress-maximize-events",
     match = { class = ".*" },
     suppress_event = "maximize",
})

-- App workspace rules
hl.window_rule({
    name = "zen-ws1",
    match = { class = "^zen$" },
    workspace = "1",
})

hl.window_rule({
    name = "discord-ws2",
    match = { class = "^discord$" },
    workspace = "2",
})

hl.window_rule({
    name = "telegram-ws2",
    match = { class = "^org\\.telegram\\.desktop$" },
    workspace = "2",
})

hl.window_rule({
    name = "throne-ws10",
    match = { class = "^Throne$" },
    workspace = "10 silent",
})

hl.window_rule({
    name = "qpwgraph-ws10",
    match = { class = "^org\\.rncbc\\.qpwgraph$" },
    workspace = "10",
})

hl.window_rule({
    name = "imv",
    match = { class = "imv" },
    
    float = true,
    size = "1720 960",
    center = true,
})

hl.window_rule({
    name = "mpv",
    match = { class = "mpv" },

    float = true,
    size = "1720 960",
    center = true,
})

hl.window_rule({
    name = "Wiremix",
    match = { class = "Wiremix" },

    float = true,
    size = "1080 480",
    center = true,
})

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
