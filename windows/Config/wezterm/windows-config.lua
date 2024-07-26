local wezterm = require 'wezterm'
local OSUtils = require 'os-utils'
local act = wezterm.action

local M = {}

function M.config()
  local os = OSUtils.getOS()

  if os ~= 'Windows' then
    return {}
  end

  local fh, err = assert(io.popen('pwsh -Command "(Get-Command pwsh).Source"'))
  local pwsh = 'C:\\Program Files\\PowerShell\\7\\pwsh.exe'
  if fh then
    pwsh = fh:read()
  end

  return {
    default_prog = { pwsh },
    keys = {
      { key = 'V', mods = 'CTRL', action = act.PasteFrom 'ClipBoard' },
    }
  }
end

return M
