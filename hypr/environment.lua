hl.env("GTK_THEME", "Adwaita:dark")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("GSK_RENDERER", "ngl")

-- Qt/Wayland compatibility, no theme-bridge package (qt5ct/qt6ct/breeze) required
hl.env("QT_QPA_PLATFORM", "wayland,xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_WAYLAND_RECONNECT", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- Requires the nvidia-vaapi-driver package (not installed on this machine yet)
-- for LIBVA_DRIVER_NAME to actually find an NVIDIA VA-API driver to use.
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.env("SDL_VIDEODRIVER", "wayland")

hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.env("CLUTTER_BACKEND", "wayland")

-- XDG Hyprland
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("WAYLAND_DISPLAY", "wayland-1")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("COLORTERM", "truecolor")
hl.env("TERMINFO", "/usr/lib/kitty/terminfo")
hl.env("TERM", "xterm-256color")

-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card0")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")

-- Uses first intel igpu then nvidia gpu (first-listed device is the primary
-- renderer, later ones are fallback, per Hyprland/Aquamarine's Multi-GPU docs)
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")

hl.env("CHROME_BIN", "/usr/bin/microsoft-edge-stable")
