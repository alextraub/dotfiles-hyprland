-- Monitors: the two desk screens, then anything else at its preferred mode
hl.monitor({
  output   = "desc:Microstep MAG274QRF-QD CA8A291700643",
  mode     = "2560x1440@164.84Hz",
  position = "0x0",
  scale    = 1,
})
hl.monitor({
  output   = "desc:ASUSTek COMPUTER INC PG27AQDM S3LMRS014609",
  mode     = "2560x1440@239.97Hz",
  position = "2560x0",
  scale    = 1,
})
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = "auto",
})

-- Configs
require("modules.env")
require("modules.general")
require("modules.input")
require("modules.misc")
require("modules.animations")
require("modules.decoration")
require("modules.autostarts")
require("modules.rules")
require("modules.keybinds")

-- Monitor roles (which workspaces live on which screen) and the Vicinae launcher
require("modules.roles")
require("modules.launcher")
