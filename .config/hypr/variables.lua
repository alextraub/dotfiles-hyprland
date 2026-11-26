-- Settings the other files read
local wal = require("wal") -- pywal16's colors, see wal.lua

return {
  -- Apps
  terminal                   = "ghostty",
  browser                    = "firefox",
  editor                     = "codium",
  fileExplorer               = "thunar",
  audioSettings              = "pwvucontrol",

  -- Touchpad
  touchpadDisableTyping      = true,
  touchpadScrollFactor       = 0.3,

  -- Blur
  blurEnabled                = true,
  blurPopups                 = true,
  blurInputMethods           = true,
  blurSize                   = 8,
  blurPasses                 = 2,
  blurXray                   = false,

  -- Shadow
  shadowEnabled              = true,
  shadowRange                = 15,
  shadowRenderPower          = 4,
  shadowColour               = "rgba(" .. wal.background .. "ed)",

  -- Gaps
  workspaceGaps              = 20,
  windowGapsIn               = 5,
  windowGapsOut              = 10,
  singleWindowGapsOut        = 20,

  -- Window styling. Borders go from the accent (color5) to the hint (color14); inactive
  -- ones are the background lightened 14%
  windowOpacity              = 0.95,
  windowRounding             = 15,
  windowRoundingPower        = 2,
  windowBorderSize           = 1,
  activeWindowBorderColour   = { colors = { "rgb(" .. wal.color5 .. ")", "rgb(" .. wal.color14 .. ")" }, angle = 45 },
  inactiveWindowBorderColour = "rgba(" .. wal.lighten(wal.background, 0.14) .. "ab)",

  -- Misc
  volumeStep                 = 10,
  volumeMax                  = 100,
  cursorTheme                = "Sweet-cursors", -- Folder name from the AUR sweet-cursors-git package
  cursorSize                 = 24,
  sleepCmd                   = "systemctl suspend-then-hibernate",

  ------------------
  ---- KEYBINDS ----
  ------------------
  -- Each is a single bind or an array of them. Workspace digits are in modules/keybinds.lua

  -- Workspaces
  kbMoveWinToWsNext          = { "SUPER + ALT + mouse_down", "SUPER + ALT + Page_Down", "CTRL + SUPER + SHIFT + Right" },
  kbMoveWinToWsPrev          = { "SUPER + ALT + mouse_up", "SUPER + ALT + Page_Up", "CTRL + SUPER + SHIFT + Left" },
  kbNextWs                   = { "SUPER + mouse_down", "CTRL + SUPER + Right", "SUPER + Page_Down" },
  kbPrevWs                   = { "SUPER + mouse_up", "CTRL + SUPER + Left", "SUPER + Page_Up" },

  -- Window actions. SUPER + Minus / Equal zoom instead (modules/keybinds.lua)
  kbWindowDecreaseWidth      = "SUPER + ALT + Left",
  kbWindowIncreaseWidth      = "SUPER + ALT + Right",
  kbWindowDecreaseHeight     = { "SUPER + SHIFT + Minus", "SUPER + ALT + Up" },
  kbWindowIncreaseHeight     = { "SUPER + SHIFT + Equal", "SUPER + ALT + Down" },

  kbMoveWindow               = "SUPER + Z",
  kbResizeWindow             = "SUPER + X",
  kbCenterWindow             = "CTRL + SUPER + Backslash",
  kbNormalizeWindow          = "CTRL + SUPER + ALT + Backslash",
  kbPinWindow                = "SUPER + P",
  kbWindowFullscreen         = "SUPER + F",
  kbWindowBorderedFullscreen = "SUPER + ALT + F",
  kbToggleWindowFloating     = "SUPER + ALT + Space",
  kbCloseWindow              = "SUPER + Q",

  -- Apps
  kbTerminal                 = "SUPER + Return",
  kbBrowser                  = "SUPER + W",
  kbEditor                   = "SUPER + C",
  kbFileExplorer             = "SUPER + E",
  kbAudioSettings            = "CTRL + ALT + V",

  -- Utilities
  kbColorPicker              = "SUPER + SHIFT + C",
  kbVolumeMute               = "SUPER + SHIFT + M",
  kbSleep                    = "SUPER + SHIFT + L",
  kbLogout                   = { "SUPER + SHIFT + E", "CTRL + ALT + Delete" }, -- Back to the SDDM greeter
  kbReadSelection            = "SUPER + T", -- Reads the selected text aloud; again to stop,

  kbScreenshot               = "SUPER + SHIFT + Print",
  screenshotDir              = "~/Pictures/Screenshots",
}
