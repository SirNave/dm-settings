hl.device({
    name = "logitech-mx-ergo-multi-device-trackball-",
    sensitivity = -0.5,
    accel_profile = "adaptive",
})

hl.device({
    name = "ven_04f3:00-04f3:32ea-touchpad",
    sensitivity = 0.5,
    accel_profile = "adaptive",
})

hl.device({
    name = "keychron-m6-mouse",
    sensitivity = 0,
    accel_profile = "adaptive",
})

hl.device({
    name = "keychron-keychron-ultra-link-8k",
    sensitivity = 0,
    accel_profile = "flat",
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.config({
    input = {
        kb_layout = "us, br",
        kb_variant = "intl, abnt2",
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",
        follow_mouse = 2,
        resolve_binds_by_sym = true,
        touchpad = {
            disable_while_typing = true,
            natural_scroll = true,
        },
    },
})

