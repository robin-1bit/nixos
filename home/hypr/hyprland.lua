-- #######################################################################################
-- HYPRLAND CONFIG — ported from hyprland.conf (legacy hyprlang) to hyprland.lua
-- Requires Hyprland >= 0.55 (Lua config was introduced in 0.55; see hypr.land/news/26_lua/)
-- Wiki root: https://wiki.hypr.land/Configuring/Start/
-- #######################################################################################

------------------
---- MONITORS ----
------------------
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
-- old: monitor=,preferred,auto,1
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "alacritty"
local fileManager = "nautilus"
local menu        = "wofi --show drun" -- not bound to a key in the original, kept for reuse

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- (consolidated here — the original had GDK_BACKEND/XDG_* under the MONITORS section
-- and XCURSOR_* under its own ENVIRONMENT VARIABLES section; functionally identical)
hl.env("GDK_BACKEND",         "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XCURSOR_THEME",       "Adwaita")
hl.env("XCURSOR_SIZE",        "24")

-------------------
---- AUTOSTART ----
-------------------
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- hl.on("hyprland.start", ...) = runs once at launch only, same as the old exec-once
-- (NOT re-run on every config reload, unlike a bare hl.exec_cmd() at file scope)
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("gammastep -P -O 4000")
hl.exec_once("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
hl.exec_once("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")
end)

-----------------------
----- PERMISSIONS -----
-----------------------
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Commented out in the original config — left disabled here too.
-- Requires a full Hyprland restart to apply (not live-reloadable), for security reasons.
-- hl.config({
--     ecosystem = { enforce_permissions = true },
-- })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------
-- https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 2,

        -- solid colors carry over as plain "rgba(...)" strings;
        -- gradients would use { colors = {...}, angle = N } instead
        col = {
            active_border   = "rgba(70707099)",
            inactive_border = "rgba(40404066)",
        },

        resize_on_border = false,
        -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 10,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a, -- old: rgba(1a1a1aee) -> new: 0xAARRGGBB number
        },

        -- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
        blur = {
            enabled           = true,
            size              = 8,
            passes            = 3,
            new_optimizations = true,
            vibrancy          = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default bezier curves — https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}   } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

-- Animations — on/off flags, speeds and curves carried over exactly from the original,
-- including which sub-animations were disabled (windowsIn/Out and all 3 workspaces* were off)
hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = false, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = false, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = false, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = false, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = false, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-------------------------------------------------------------------
---- SMART GAPS/BORDERS (no gaps/border when solo or fullscreen) ----
-------------------------------------------------------------------
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- w[tv1] = workspace with exactly 1 visible tiled window
-- f[1]   = workspace with a window in maximized/fullscreen mode
-- These two were ACTIVE (uncommented) in the original, so they're active here too.
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0, border_size = 0, no_rounding = true })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0, border_size = 0, no_rounding = true })

-- Alternative windowrule-based method for the same effect — commented out in the
-- original as a documented alternative. Use ONE method, not both at once.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({ name = "no-gaps-wtv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
-- hl.window_rule({ name = "no-gaps-f1",   match = { float = false, workspace = "f[1]" },   border_size = 0, rounding = 0 })

-- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
hl.config({
    master = {
        new_status = "master",
    },
})

----------------
---- MISC ----
----------------
hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 2,
        sensitivity  = 0.4, -- -1.0 to 1.0, 0 means no modification

        touchpad = {
            natural_scroll = false,
        },
    },

    -- `cursor` is its own top-level category, same as in hyprlang (not nested under input)
    cursor = {
        no_warps = false,
    },
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- Commented out in the original: # gesture = 3, horizontal, workspace
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Example per-device config — https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
-- NOTE: "epic-mouse-v1" is Hyprland's own placeholder device name from its stock example
-- config, not a real device — carried over from the original as-is. It's inert until you
-- rename it to match a real device name from `hyprctl devices`.
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- TODO (carried over verbatim from the original, which had this comment but no rule under it):
-- "Force Ghidra windows to tile instead of float"
-- hl.window_rule({ name = "ghidra-tile", match = { class = "ghidra" }, float = false })

---------------------
---- KEYBINDINGS ----
---------------------
-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers/
-- All binds from all three places in the original file (the early "Custom keybinds" block,
-- the main generated block, and the tail of "Windows and workspaces") are consolidated here.
local mainMod = "SUPER"

-- Apps / launchers
hl.bind("CTRL + SHIFT + Y", hl.dsp.exec_cmd("zen-browser --private-window"))
hl.bind(mainMod .. " + Y",  hl.dsp.exec_cmd("zen-browser"))
hl.bind(mainMod .. " + Q",  hl.dsp.exec_cmd("brave-origin --force-dark-mode --enable-features=WebUIDarkMode --force-device-scale-factor=1.20"))
hl.bind(mainMod .. " + P",  hl.dsp.exec_cmd("protonvpn-app"))
hl.bind(mainMod .. " + I",  hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",  hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + O",  hl.dsp.exec_cmd("~/.config/rofi/launchers/type-2/launcher.sh"))

-- Lock screen (bound to two different combos in the original — both kept)
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("hyprlock"))

-- Close active window / exit Hyprland
hl.bind(mainMod .. " + U", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Focus movement — arrow keys AND vim-style hjkl (both were bound in the original)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down"  }))

-- Fullscreen (old: `fullscreen, 1` = maximize-toggle)
-- NOTE: this dispatcher's table shape has been actively revised across 0.55.x point releases
-- (see hyprwm/Hyprland discussions #14494 and #14646). This form is confirmed working as of
-- this writing; if it misbehaves after an update, recheck the Dispatchers wiki page above.
hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Workspaces 1-10, and move-active-window-to-workspace 1-10 (SUPER+SHIFT)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad (special workspace)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move / resize windows by dragging with the mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize the active window from the keyboard (old: binde ... resizeactive, ±20px)
hl.bind("SUPER + SHIFT + h", hl.dsp.window.resize({ x = -20, y = 0   }), { repeating = true })
hl.bind("SUPER + SHIFT + l", hl.dsp.window.resize({ x = 20,  y = 0   }), { repeating = true })
hl.bind("SUPER + SHIFT + k", hl.dsp.window.resize({ x = 0,   y = -20 }), { repeating = true })
hl.bind("SUPER + SHIFT + j", hl.dsp.window.resize({ x = 0,   y = 20  }), { repeating = true })

-- Multimedia keys
-- `repeating = true` ~= old "binde" (repeats while the key is held)
-- `locked = true`    ~= old "bindl" (still fires while the screen is locked)
-- Carried over exactly as split in the original: volume keys were binde-only (no lock
-- persistence), mic/brightness/media were bindl-only (no repeat). See note below the file
-- if you'd rather have volume also work while locked.
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume +5"),           { repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume -5"),           { repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),  { repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness +2"),               { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -2"),               { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),                               { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"),                         { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),                         { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),                           { locked = true })

-- Screenshots
hl.bind("ALT + o", hl.dsp.exec_cmd("~/.config/hypr/screenshot-area.sh"))
hl.bind("ALT + p", hl.dsp.exec_cmd("~/.config/hypr/screenshot-full.sh"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- All three were commented out in the original — left disabled here too. Uncomment to enable.

-- hl.window_rule({
--     name  = "float-kitty",
--     match = { class = "^(kitty)$", title = "^(kitty)$" },
--     float = true,
-- })

-- Ignore maximize requests from apps. You'll probably like this.
-- hl.window_rule({
--     name           = "suppress-maximize-events",
--     match          = { class = ".*" },
--     suppress_event = "maximize",
-- })

-- Fix some dragging issues with XWayland
-- hl.window_rule({
--     name  = "fix-xwayland-drags",
--     match = {
--         class      = "^$",
--         title      = "^$",
--         xwayland   = true,
--         float      = true,
--         fullscreen = false,
--         pin        = false,
--     },
--     no_focus = true,
-- })
