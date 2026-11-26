local vars = require("variables")

-- Flags
local locked           = { locked = true }
local mouse            = { mouse = true }
local repeating        = { repeating = true }
local locked_repeating = { locked = true, repeating = true }

-- Binds one key or each key in an array. flags can be a function of the key
local function bind(keys, action, flags)
  if type(keys) == "string" then keys = { keys } end
  for _, key in ipairs(keys) do
    hl.bind(key, action, type(flags) == "function" and flags(key) or flags)
  end
end

local function repeating_unless_mouse(key)
  return not key:lower():find("mouse", 1, true) and repeating or nil
end

-- Resizes the active window by a percentage of its size
local function resize_active_window(x, y)
  return function()
    local win = hl.get_active_window()
    if win and win.size then
      hl.dispatch(hl.dsp.window.resize({ x = win.size.x * x / 100, y = win.size.y * y / 100, relative = true }))
    end
  end
end

-- Go to workspace -1/+1
bind(vars.kbPrevWs, hl.dsp.focus({ workspace = "-1" }), repeating_unless_mouse)
bind(vars.kbNextWs, hl.dsp.focus({ workspace = "+1" }), repeating_unless_mouse)

-- Move window to workspace -1/+1
bind(vars.kbMoveWinToWsNext, hl.dsp.window.move({ workspace = "+1" }), repeating_unless_mouse)
bind(vars.kbMoveWinToWsPrev, hl.dsp.window.move({ workspace = "-1" }), repeating_unless_mouse)

-- Window actions
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  bind("SUPER + " .. dir, hl.dsp.focus({ direction = dir }))
  bind("SUPER + SHIFT + " .. dir, hl.dsp.window.move({ direction = dir }))
end

bind(vars.kbWindowDecreaseWidth, resize_active_window(-10, 0), repeating)
bind(vars.kbWindowIncreaseWidth, resize_active_window(10, 0), repeating)
bind(vars.kbWindowDecreaseHeight, resize_active_window(0, -10), repeating)
bind(vars.kbWindowIncreaseHeight, resize_active_window(0, 10), repeating)

bind({ vars.kbMoveWindow, "SUPER + mouse:272" }, hl.dsp.window.drag(), mouse)
bind({ vars.kbResizeWindow, "SUPER + mouse:273" }, hl.dsp.window.resize(), mouse)
bind(vars.kbCenterWindow, hl.dsp.window.center())
-- 55% x 70% of the monitor, centered
bind(vars.kbNormalizeWindow, function()
  local m = hl.get_active_monitor()
  if not m then return end
  hl.dispatch(hl.dsp.window.resize({ x = math.floor(m.width * 0.55), y = math.floor(m.height * 0.7), relative = false }))
  hl.dispatch(hl.dsp.window.center())
end)
bind(vars.kbPinWindow, hl.dsp.window.pin())
bind(vars.kbWindowFullscreen, hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(vars.kbWindowBorderedFullscreen, hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(vars.kbToggleWindowFloating, hl.dsp.window.float())
bind(vars.kbCloseWindow, hl.dsp.window.close())

-- Apps
bind(vars.kbTerminal, hl.dsp.exec_cmd(vars.terminal))
bind(vars.kbBrowser, hl.dsp.exec_cmd(vars.browser))
bind(vars.kbEditor, hl.dsp.exec_cmd(vars.editor))
bind(vars.kbFileExplorer, hl.dsp.exec_cmd(vars.fileExplorer))

-- Volume
bind({ vars.kbVolumeMute, "XF86AudioMute" }, hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked)
bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)
bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd(
    "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l " ..
    (vars.volumeMax / 100) .. " @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%+"
  ),
  locked_repeating
)
bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd(
    "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%-"
  ),
  locked_repeating
)

-- Log out to the SDDM greeter, closing apps gracefully first
bind(vars.kbLogout, hl.dsp.exec_cmd("hyprshutdown"))

-- Sleep
bind(vars.kbSleep, hl.dsp.exec_cmd(vars.sleepCmd), locked)

-- Text to speech
bind(vars.kbReadSelection, hl.dsp.exec_cmd("~/.config/hypr/scripts/tts-selection.sh"))


local zoomBy = require("modules.zoom").zoomBy
local swapMonitors = require("modules.swap").swapMonitors
local screenWorkspace = require("modules.roles").screenWorkspace
local toggleLauncher = require("modules.launcher").toggle

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
hl.bind(mainMod .. " + equal", zoomBy(0.5),  { repeating = true })
hl.bind(mainMod .. " + minus", zoomBy(-0.5), { repeating = true })

-- Tapping SUPER on its own toggles Vicinae. Hyprland only fires a release bind when the released key
-- was the last one pressed, so SUPER + key binds already skip it, but mouse buttons don't count, so
-- clicks while SUPER is held (a SUPER + drag) are tracked here. It does nothing over a fullscreen
-- window
local superClicked = false
local passThrough = { non_consuming = true }
-- SUPER isn't in the modifier state yet while SUPER_L itself goes down, so this matches each fresh press
hl.bind("SUPER_L", function() superClicked = false end, passThrough)
hl.bind(mainMod .. " + mouse:272", function() superClicked = true end, passThrough)
hl.bind(mainMod .. " + mouse:273", function() superClicked = true end, passThrough)
hl.bind(mainMod .. " + SUPER_L", function()
  local active = hl.get_active_window()
  if superClicked or (active and active.fullscreen ~= 0) then return end
  toggleLauncher()
end, { release = true })

hl.bind(mainMod .. " + SHIFT + Tab", swapMonitors)

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- 1-5 are the right screen's workspaces and 6-0 the left's, whichever IDs each holds after a swap
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  local screen = (i <= 5) and "right" or "left"
  local k = (i - 1) % 5 + 1
  hl.bind(mainMod .. " + " .. key, function()
    hl.dispatch(hl.dsp.focus({ workspace = screenWorkspace(screen, k, i) }))
  end)
  hl.bind(mainMod .. " + SHIFT + " .. key, function()
    hl.dispatch(hl.dsp.window.move({ workspace = screenWorkspace(screen, k, i) }))
  end)
end
