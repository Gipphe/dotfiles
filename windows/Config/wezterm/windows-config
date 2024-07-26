local wezterm = require 'wezterm'
local OSUtils = require 'os-utils'
local act = wezterm.action

local M = {}

function M.config()
  local os = OSUtils.getOS()

  if os != 'Windows' then
    return {}
  end

  return {
    default_prog = { 'pwsh' },
    keys = {
      { key = 'V', mods = 'CTRL', action = act.PasteFrom 'ClipBoard' },
    }
  }
end

return M
