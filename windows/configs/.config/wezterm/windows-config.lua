local wezterm = require 'wezterm'
local OSUtils = require 'os-utils'
local act = wezterm.action

local M = {}

function M.config()
  if not OSUtils.isWindows() then
    return {}
  end

  return {
    font_size = 9.0,
    initial_rows = 40,
    initial_cols = 200,
    default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe' },
    keys = {
      { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    }
  }
end

return M
