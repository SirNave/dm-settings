hl.window_rule({
    name = "VideoBridge-Float-Center",
    match = {
        class = "^(xwaylandvideobridge)$",
    },
    opacity = "0.0 override",
    no_anim = true,
    no_initial_focus = true,
    max_size = "1 1",
    no_blur = true,
    no_focus = true,
})

hl.window_rule({
    name = "Qalculate-Float-Center",
    match = {
        title = "(Qalculate!)$",
    },
    size = "400 400",
    center = true,
    float = true,
})

hl.window_rule({
    name = "Calculator-Float-Center",
    match = {
        initial_class = "(org.gnome.Calculator)$",
    },
    size = "400 620",
    center = true,
    float = true,
})

hl.window_rule({
    name = "Xsensors-Float-Center",
    match = {
        initial_class = "(xsensors)$",
    },
    size = "610 610",
    center = true,
    float = true,
})

hl.window_rule({
    name = "Calendar-Float-Center",
    match = {
        class = "(org.gnome.Calendar)$",
    },
    size = "400 600",
    center = true,
    float = true,
})

hl.window_rule({
    name = "Volume-Float-Center",
    match = {
        title = "^(Volume Control)$",
    },
    float = true,
    center = true,
    size = "1500 900",
})

hl.window_rule({
    name = "Blueman-Float-Center",
    match = {
        class = "^(blueman-manager)$",
    },
    float = true,
    center = true,
    size = "1500 900",
})

hl.window_rule({
    name = "Network-Float-Center",
    match = {
        class = "^(nm-connection-editor)$",
    },
    float = true,
    center = true,
    size = "800 900",
})

hl.window_rule({
    name = "Kyitty-Animation",
    match = {
        class = "kitty",
    },
    animation = "fade",
})

hl.window_rule({
    name = "FullScreen-Border",
    match = {
        fullscreen = 1,
    },
    border_color = "rgba(FF0000FF) rgba(880808FF)",
})

hl.window_rule({
    name = "Hyperland-Border",
    match = {
        title = "^(.*hyprland.*|.*Hyprland.*)$",
    },
    border_color = "rgba(FFFF00FF) rgba(880808FF)",
})

hl.window_rule({
    name = "Float-Border",
    match = {
        float = 1,
    },
    border_color = "rgba(FF0000FF) rgba(FF8888AA)",
})

hl.window_rule({
    name = "JetBrains-Focus",
    match = {
        class = "jetbrains-idea",
        float = true,
    },
    border_color = "rgba(FF00FFFF) rgba(FF8888AA)",
})

hl.window_rule({
    name = "JetBrains-NoFocus",
    match = {
        class = "jetbrains-idea",
        title = "^(.*win.*)$",
    },
    no_initial_focus = true,
    animation = "fade",
})

hl.window_rule({
    name = "JetBrains-Focus",
    match = {
        class = "jetbrains-idea",
        title = "(^$)",
    },
    stay_focused = true,
})

hl.window_rule({
    name = "Satty-Rule",
    match = {
        class = "(com.gabm.satty)",
        title = "(satty)",
    },
    float = true,
    center = true,
    animation = "fade",
    stay_focused = true,
})

hl.window_rule({
    name = "Karma-Rule",
    match = {
        class = "microsoft-edge",
        title = "^(Karma - Work*)$",
    },
    float = true,
    center = false,
    animation = "fade",
})

hl.window_rule({
    name = "Emulator-Rule",
    match = {
        class = "Emulator",
    },
    float = true,
    center = true,
})

