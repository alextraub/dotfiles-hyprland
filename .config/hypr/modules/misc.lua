local wal = require("wal") -- pywal16's colors, see wal.lua

hl.config({
  misc = {
    animate_manual_resizes       = false,
    animate_mouse_windowdragging = false,

    disable_hyprland_logo        = true,
    force_default_wallpaper      = 0,

    on_focus_under_fullscreen    = 2,
    allow_session_lock_restore   = true,
    middle_click_paste           = true, -- Also turns on the primary selection that scripts/tts-selection.sh reads
    focus_on_activate            = true,
    session_lock_xray            = true,

    mouse_move_enables_dpms      = true,
    key_press_enables_dpms       = true,

    background_color             = "rgb(" .. wal.lighten(wal.background, 0.05) .. ")",
    vrr                          = 2,
  },

  debug = {
    error_position = 1
  }
})
