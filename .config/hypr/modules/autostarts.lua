local vars = require("variables")

hl.on("hyprland.start", function()
  -- Keyring and auth
  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
  -- reset-failed: a Hyprland restart can leave it start-limit-hit
  hl.exec_cmd("systemctl --user reset-failed hyprpolkitagent; systemctl --user start hyprpolkitagent")

  -- Auto delete trash 30 days old
  hl.exec_cmd("trash-empty 30")

  -- Cursors
  hl.exec_cmd("hyprctl setcursor " .. vars.cursorTheme .. " " .. vars.cursorSize)
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme " .. vars.cursorTheme)
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size " .. vars.cursorSize)

  -- Forward bluetooth media commands to MPRIS
  hl.exec_cmd("mpris-proxy")

  -- Idle: screen off after 5 minutes (hypridle.conf)
  hl.exec_cmd("hypridle")

  -- Launcher. Vicinae aborts at startup without a Secret Service on D-Bus, so wait for
  -- gnome-keyring (started above, unlocked by SDDM's pam_gnome_keyring) to claim the name first
  hl.exec_cmd("until busctl --user status org.freedesktop.secrets >/dev/null 2>&1; do sleep 0.2; done; vicinae server")

  -- Audio routing
  hl.exec_cmd("pipeweaver-daemon --background")

  -- Wallpaper daemon
  hl.exec_cmd("awww-daemon")
end)
