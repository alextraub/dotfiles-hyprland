#!/bin/sh
# Hyprland: the config's wal.lua reads colors.json for the window borders, shadow and
# group bar when the config loads, so reload it
[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] && hyprctl reload >/dev/null
exit 0
