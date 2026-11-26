-- pywal16's colors, read from ~/.cache/wal/colors.json. Each key is background,
-- foreground, cursor or color0..color15, as "rrggbb" without the "#". Read by
-- variables.lua and modules/misc.lua. This package's ~/.config/wal/post-wal.d/hyprland.sh
-- hook runs `hyprctl reload` after every wal, so Hyprland picks up new colors. Until wal
-- has run, or without pywal16, the keys used fall back to the colors below.

local cache = os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")
local colors = {}

local f = io.open(cache .. "/wal/colors.json", "r")
if f then
  local raw = f:read("*a")
  f:close()
  -- colors.json is flat "name": "#rrggbb" pairs inside "special" and "colors"
  for name, hex in raw:gmatch('"(%w+)"%s*:%s*"#(%x%x%x%x%x%x)"') do
    colors[name] = hex:lower()
  end
end

local fallback = { background = "131317", color5 = "c2c1ff", color14 = "f5b2e0" }
for name, hex in pairs(fallback) do
  colors[name] = colors[name] or hex
end

-- pywal's lighten(): mix toward white by amount (0..1)
function colors.lighten(hex, amount)
  local out = ""
  for i = 1, 5, 2 do
    local c = tonumber(hex:sub(i, i + 1), 16)
    out = out .. string.format("%02x", math.floor(c + (255 - c) * amount))
  end
  return out
end

return colors
