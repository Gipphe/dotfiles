local wezterm = require 'wezterm'
local OSUtils = require 'os-utils'
local act = wezterm.action

local M = {}

function M.config()
  if not OSUtils.isWindows() then
    return {}
  end

  return {
    default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe' },
    keys = {
      { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    }
  }
end

return M
