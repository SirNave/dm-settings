hl.monitor({
    output = "eDP-2",
    mode = "2560x1600@240",
    position = "0x0",
    scale = "1.6",
})

hl.monitor({
    output = "desc:Dell Inc. DELL P2425H 36FG8F4",
    mode = "1920x1080@100",
    position = "1600x0",
    scale = "1",
})

hl.monitor({
    output = "desc:Dell Inc. DELL P2425H 5TRG8F4",
    mode = "1920x1080@100",
    position = "3520x0",
    scale = "1",
})

hl.monitor({
    output = "desc:LG Electronics LG ULTRAWIDE 0x01010101",
    -- mode = "2560x1080@75", -- Work
    mode = "2560x1080@74.99", -- Home
    -- position = "1600x0", -- Work
    position = "3440x-650", -- Home
    scale = "1",
    transform = 3 -- Home
})

hl.monitor({
    output = "desc:Xiaomi Corporation Mi monitor 5505610163175",
    mode = "3440x1440@120",
    -- position = "-3440x0", -- Work
    position = "0x0", -- Home
    scale = "1",
    -- cm = hdr, -- valid value, but confirmed Hyprland bug washes out SDR/lifts black, see discussion #14803, issue #15195
    -- cm = hdredid, -- same tone-mapping pipeline as hdr, same bug applies
    cm = dcip3, -- best option if ever enabling this: gamut-only remap (no tone-mapping,
                  -- no known bug), matches this panel's real ~92-95% DCI-P3 coverage (unlike
                  -- "wide"/BT.2020 which washes out on a panel that can't cover that gamut).
                  -- If enabled, also set render.cm_auto_hdr = 0 above (see note there).
    supports_wide_color = 1,
    supports_hdr = 1,
    sdr_min_luminance = 0.005,
    sdr_max_luminance = 350,
    min_luminance = 0.005,
    max_luminance = 450,
    max_avg_luminance = 350,
    sdrsaturation = 0.98,
    sdrbrightness = 1.2,
    bitdepth = 10,
})

-- Fallback for any monitor not explicitly matched above (e.g. a new/unknown
-- one plugged into the dock); must stay last so the named rules above take
-- precedence.
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

