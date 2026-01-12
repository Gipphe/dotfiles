local wezterm = require("wezterm")
local utils = require("utils")

local M = {}

function M.config()
	if not utils.isLinux() then
		return {}
	end

	return {
		enable_wayland = false,
	}
end

return M
