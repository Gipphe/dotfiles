local wezterm = require 'wezterm'
local OSUtils = require 'os-utils'

local M = {}

function M.config()
  if not OSUtils.isLinux() then
    return {}
  end

  return {
    enable_wayland = false,
  }
end

return M
