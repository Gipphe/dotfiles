local wezterm = require("wezterm")
local stylix_config = require("stylix")
local user_config = require("config")

local config = wezterm.config_builder and wezterm.config_builder() or {}
for k, v in pairs(stylix_config)
  config[k] = v
end
for k, v in pairs(user_config)
  config[k] = v
end

return config
