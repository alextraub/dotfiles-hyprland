# hyprland dependencies

Stowing this package links `~/.config/hypr/{hyprland.lua,variables.lua,wal.lua,modules,scripts,hypridle.conf,hyprpaper.conf,.luarc.json}` and `~/.config/wal/post-wal.d/hyprland.sh`. Install the following first.

`hyprland.lua` sets the monitors and loads `modules/`. Settings and keybinds that those modules read live in `variables.lua`. Colors come from pywal16 through `wal.lua`. No desktop shell runs, so there is no bar, notification daemon or lock bind. Apps below are the ones `variables.lua` and `modules/autostarts.lua` pick; if you change one there, install that instead.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Hyprland >= 0.55 | Lua config (`hyprland.lua`, `hl.*` API) was introduced in 0.55. Tested on 0.57.2. `.luarc.json` points the Lua language server at the API stubs Hyprland ships in `/usr/share/hypr/stubs` | https://wiki.hypr.land/Getting-Started/Installation/ |
| pywal16 and the theming repo's `wal` package | Border, shadow and background colors (`variables.lua` and `modules/misc.lua`, through `wal.lua`). The `wal` package's `post-wal.sh` runs this package's `post-wal.d/hyprland.sh` hook, which runs `hyprctl reload` after every `wal`. Without pywal16 `wal.lua` falls back to built-in colors and the hook never runs | https://github.com/eylles/pywal16 |
| Ghostty | `terminal` in `variables.lua`, bound to `SUPER + Return` | https://ghostty.org/docs/install/binary |
| Firefox | `browser` in `variables.lua`, bound to `SUPER + W` | https://www.firefox.com/ |
| VSCodium (`codium`) | `editor` in `variables.lua`, bound to `SUPER + C` | https://vscodium.com/#install |
| Thunar | `fileExplorer` in `variables.lua`, bound to `SUPER + E` | https://docs.xfce.org/xfce/thunar/start |
| WirePlumber (`wpctl`) + PipeWire | Volume and mute keys (`XF86Audio*`, `SUPER + SHIFT + M`) in `modules/keybinds.lua` | https://pipewire.pages.freedesktop.org/wireplumber/ |
| hyprpolkitagent | Started by `modules/autostarts.lua`, for password prompts from apps that need elevated rights. The command runs `systemctl --user reset-failed` first: when Hyprland restarts without a full logout, the unit keeps restarting with no compositor, hits systemd's start limit, and would otherwise refuse to start in the new session | https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent/ |
| gnome-keyring | `gnome-keyring-daemon --start --components=secrets` in `modules/autostarts.lua`. Provides the D-Bus Secret Service that `vicinae server` waits for (polled with `busctl`); Vicinae aborts at startup (`Database keychain unavailable`) without one. Unlocked with the login password by `pam_gnome_keyring.so` in the login manager's PAM file (SDDM ships it) | https://wiki.gnome.org/Projects/GnomeKeyring |
| Vicinae | `vicinae server` from `modules/autostarts.lua`; opened and closed by tapping `SUPER` (`modules/keybinds.lua`). `modules/launcher.lua` places it at the cursor and closes it on outside clicks, which needs `"launcher_window": { "layer_shell": { "enabled": false } }` in `~/.config/vicinae/settings.json` (not tracked). AUR on Arch (`vicinae-bin`) | https://vicinae.com/docs |
| hypridle | Started by `modules/autostarts.lua`; reads `hypridle.conf` (screen off after 5 min, lock before sleep) | https://wiki.hypr.land/Hypr-Ecosystem/hypridle/ |
| hyprlock | `lock_cmd` in `hypridle.conf`. No `hyprlock.conf` is tracked here, so it runs with its defaults | https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/ |
| hyprshutdown | `SUPER + SHIFT + E` and `CTRL + ALT + Delete` (`kbLogout` in `variables.lua`) run it to close apps gracefully before logging out to the greeter. Without it those binds do nothing | https://github.com/hyprwm/hyprshutdown |
| systemd (`loginctl`, `systemctl`) | `before_sleep_cmd = loginctl lock-session` in `hypridle.conf`; `sleepCmd` in `variables.lua` (`systemctl suspend-then-hibernate`) on `SUPER + SHIFT + L` | https://www.freedesktop.org/software/systemd/man/latest/loginctl.html |
| awww | `awww-daemon` from `modules/autostarts.lua` sets the wallpaper. `modules/swap.lua` also uses `awww` to wipe the wallpapers across when `SUPER + SHIFT + Tab` swaps the two monitors | https://codeberg.org/LGFae/awww |
| qtengine | `QT_QPA_PLATFORMTHEME=qtengine` in `modules/env.lua`; the theming repo's `qtengine` package's `config.json` selects pywal16's colors and the Darkly widget style (`darkly-qt6-git` in the AUR). Without qtengine Qt apps fall back to Qt's default theme; without Darkly they get the colors on a fallback style | https://github.com/kossLAN/qtengine |
| Sweet cursors (`Sweet-cursors`) | `cursorTheme` in `variables.lua`, set through `XCURSOR_THEME` in `modules/env.lua` and `hyprctl setcursor` / `gsettings` in `modules/autostarts.lua`. The untracked `~/.config/gtk-{3,4}.0/settings.ini` should name it too (`gtk-cursor-theme-name=Sweet-cursors`). Builds from source with Inkscape; export `NO_AT_BRIDGE=1` first, or each of its ~370 Inkscape runs prints an accessibility-bus warning that looks like a loop | https://github.com/Gigas002/Sweet |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed hyprland ghostty thunar pipewire wireplumber hypridle hyprlock \
  hyprshutdown awww hyprpolkitagent gnome-keyring firefox python-pywal16
yay -S vicinae-bin vscodium-bin qtengine darkly-qt6-git   # AUR, or any AUR helper
NO_AT_BRIDGE=1 yay -S --removemake sweet-cursors-git   # long Inkscape build, see the table

# Other distros: follow the Hyprland installation page. Most distro packages
# lag behind and may be older than 0.55, which cannot read this config.
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| trash-cli (`trash-empty`) | `trash-empty 30` in `modules/autostarts.lua` clears trash older than 30 days at login | https://github.com/andreafrancia/trash-cli |
| bluez-utils (`mpris-proxy`) | `mpris-proxy` in `modules/autostarts.lua` forwards Bluetooth headset media buttons to MPRIS | https://github.com/bluez/bluez |
| pipeweaver | `pipeweaver-daemon --background` in `modules/autostarts.lua` (audio routing). Only needed if you use it; AUR on Arch | https://github.com/pipeweaver/pipeweaver |
| qt5-wayland, qt6-wayland | `QT_QPA_PLATFORM=wayland;xcb` in `modules/env.lua`. Without them Qt apps fall back to XWayland | https://wiki.hypr.land/Getting-Started/Master-Tutorial/ |
| gvfs | Trash, removable drives and network locations in Thunar | https://docs.xfce.org/xfce/thunar/start |
| piper-tts + a voice, wl-clipboard | `scripts/tts-selection.sh` on `SUPER + T` (`modules/keybinds.lua`) reads the selected text (the primary selection, which needs `middle_click_paste = true` in `modules/misc.lua`) aloud through `pw-play`, and stops when pressed again. The voice defaults to `~/.local/share/piper/en_US-lessac-medium.onnx` (plus its `.onnx.json`); set `TTS_VOICE` / `TTS_SPEED` to change it. AUR on Arch (`piper-tts-bin`) | https://github.com/rhasspy/piper |
| hyprshot (pulls in grim, slurp, jq, wl-clipboard), hyprpicker | Screenshot binds in `modules/keybinds.lua`: `Print` (region), `ALT + Print` (active window) and `CTRL + Print` (monitor under the cursor) copy to the clipboard (`kbScreenshot*` in `variables.lua`). With `SHIFT` added they also save to `screenshotDir` (`~/Pictures/Screenshots`) as `Screenshot YYYY-MM-DD HH:MM:SS.png`. hyprpicker freezes the screen during region selection | https://github.com/Gustash/Hyprshot |
| hyprpicker, wl-clipboard | `SUPER + SHIFT + C` (`kbColorPicker` in `variables.lua`) runs `hyprpicker -a -r`: click a pixel to copy its hex code to the clipboard, Escape cancels. Also used by hyprshot to freeze the screen | https://github.com/hyprwm/hyprpicker |
| hyprpaper | Only `hyprpaper.conf` (`splash = false`) refers to it; it is not autostarted, awww sets the wallpaper instead | https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/ |

```sh
# Arch / CachyOS
sudo pacman -S --needed trash-cli bluez-utils qt5-wayland qt6-wayland gvfs hyprpaper wl-clipboard hyprshot hyprpicker
yay -S pipeweaver piper-tts-bin   # AUR, or any AUR helper
v=https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx
mkdir -p ~/.local/share/piper && curl -fL "$v" -o ~/.local/share/piper/en_US-lessac-medium.onnx \
  && curl -fL "$v.json" -o ~/.local/share/piper/en_US-lessac-medium.onnx.json
```

## Verify

```sh
Hyprland --version | head -1   # needs v0.55 or later
for c in Hyprland wal ghostty firefox codium thunar wpctl gnome-keyring-daemon busctl vicinae hypridle hyprlock hyprshutdown loginctl awww-daemon; do command -v "$c" >/dev/null && echo "$c ok" || echo "$c MISSING"; done
systemctl --user cat hyprpolkitagent.service >/dev/null 2>&1 && echo "hyprpolkitagent ok" || echo "hyprpolkitagent MISSING"
find /usr/lib -path '*platformthemes*' -iname '*qt6engine*' 2>/dev/null | grep -q . && echo "qtengine ok" || echo "qtengine MISSING"
find /usr/lib -path '*styles*' -iname 'darkly*' 2>/dev/null | grep -q . && echo "darkly ok" || echo "darkly MISSING"
find /usr/share/icons ~/.local/share/icons ~/.icons -maxdepth 1 -name Sweet-cursors 2>/dev/null | grep -q . && echo "Sweet-cursors ok" || echo "Sweet-cursors MISSING"
```

## After stowing

- The two desk monitors are named by their `desc:` strings in `hyprland.lua` (modes and positions) and in `DEFAULT` in `modules/roles.lua` (which one is main, holding workspaces 1-5, and which is side, holding 6-10). Change both on another machine; any other monitor gets its preferred mode.
- `SUPER + SHIFT + Tab` swaps the screens' roles for the rest of the session. The swap is saved in `~/.local/state/hypr/monitor-roles.json` so it survives `hyprctl reload`, and a fresh login undoes it.
- `modules/env.lua` sets NVIDIA's G-Sync / VRR variables (`__GL_GSYNC_ALLOWED`, `__GL_VRR_ALLOWED`); they do nothing on other GPUs.
- Colors are pywal16's, read from `~/.cache/wal/colors.json` by `wal.lua`, which falls back to a few built-in colors until `wal` has run.
- In a running session, apply changes with:

  ```sh
  hyprctl reload
  ```
