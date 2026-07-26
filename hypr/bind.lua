-- Bind helper

hl.bind("SUPER + F1", hl.dsp.exec_cmd("~/.config/hypr/keybind"))

-- general
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("hyprpicker -a -n & notify-send 'Color on Clipboard'"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("kitty ranger"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("wlogout --protocol layer-shell -b 6 -T 400 -B 400"))

-- hl.bind("SUPER + SHIFT + E", hl.dsp.exit()) -- WARNING: kills the active session, disabled to avoid accidental trigger

-- Multimedia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot Copied to Clipboard'"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region --raw | satty -f - --initial-tool brush --copy-command wl-copy --early-exit --actions-on-enter save-to-clipboard --actions-on-escape save-to-clipboard"))

--# Rofi Helpers
-- Cacl
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("killall rofi || rofi -show calc"))

-- List Files
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("killall rofi || rofi -show filebrowser"))

-- List opened windows
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("killall rofi || rofi -show window"))

-- List aplications
hl.bind("SUPER + D", hl.dsp.exec_cmd("killall rofi || rofi -show drun"))

-- Show Clipboard
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- Reload Waybar
hl.bind("CTRL + SHIFT + SUPER + R", hl.dsp.exec_cmd("killall -SIGUSR2 waybar || waybar --bar main-bar --log-level error --config $HOME/.config/waybar/config.jsonc --style $HOME/.config/waybar/style.css"))

-- Screen Brightness
hl.bind("SUPER + B", hl.dsp.exec_cmd("brightnessctl -c backlight s +2%"), { repeating = true })
hl.bind("SUPER + N", hl.dsp.exec_cmd("brightnessctl -c backlight s 2%-"), { repeating = true })

-- Window Management
hl.bind("SUPER + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
-- Use o layoutmsg para alternar a direção (antigo 'togglesplit')
hl.bind("SUPER + S", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + S", hl.dsp.layout("swapsplit"))

-- Focus window
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

-- Move window
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Resize window
hl.bind("SUPER + SHIFT + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

-- Group tabs
hl.bind("SUPER + g", hl.dsp.group.toggle())
hl.bind("SUPER + SHIFT + g", hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + SHIFT + tab", hl.dsp.group.next())

-- Workspace

hl.bind("SUPER + CTRL + left", function() local w = hl.get_active_workspace(); if not w then return end; hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "l" })) end)
hl.bind("SUPER + CTRL + down", function() local w = hl.get_active_workspace(); if not w then return end; hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "d" })) end)
hl.bind("SUPER + CTRL + up", function() local w = hl.get_active_workspace(); if not w then return end; hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "u" })) end)
hl.bind("SUPER + CTRL + right", function() local w = hl.get_active_workspace(); if not w then return end; hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "r" })) end)

hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + ALT + up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + ALT + down", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind("SUPER + CTRL + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind("SUPER + CTRL + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind("SUPER + CTRL + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind("SUPER + CTRL + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind("SUPER + CTRL + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind("SUPER + CTRL + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind("SUPER + CTRL + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind("SUPER + CTRL + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind("SUPER + CTRL + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind("SUPER + CTRL + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

hl.bind("SUPER + tab", hl.dsp.focus({ last = true }), { repeating = true })

-- Special Workspace
hl.bind("SUPER + grave", hl.dsp.workspace.toggle_special(""))
hl.bind("SUPER + SHIFT + grave", hl.dsp.window.move({ workspace = "special" }))

-- Mouse Bindings
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Submaps

-- Will switch to a submap called resize
hl.bind("SUPER + R", hl.dsp.submap("Resizing Window"))

-- Will start a submap called "resize"
hl.define_submap("Resizing Window", function()

    -- Sets repeatable binds for resizing the active window
    hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

    -- Use reset to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))

    -- Will reset the submap, meaning end the current one and return to the global one
end)

