local wezterm = require("wezterm")

local isWindows = os.getenv("COMSPEC") ~= nil and os.getenv("USERPROFILE") ~= nil

local baseConfig = {}
if wezterm.config_builder then
	baseConfig = wezterm.config_builder()
end

local config = {
	hide_tab_bar_if_only_one_tab = true,
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
	default_cursor_style = "BlinkingBar",
	-- See https://github.com/wez/wezterm/issues/5990
	front_end = "WebGpu",
	-- Disable easing for cursor, blinking text and visual bell
	animation_fps = 1,
	warn_about_missing_glyphs = false,
	-- claude-code shift-enter fix
	keys = {
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action({ SendString = "\\x1b\\r" }),
	},
}

if isWindows then
	config.font_size = 9.0
	config.initial_rows = 40
	config.initial_cols = 200
	config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }
	config.keys = {
		{ key = "V", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
	}
end

if not isWindows then
	config.enable_wayland = false
end

-- Strip Zellij session name from window title
wezterm.on("format-window-title", function(tab, _pane, _tabs, _panes, _config)
	local title = tab.active_pane.title
	-- Remove Zellij session name pattern: "session-name | actual-title"
	local stripped = title:match("^[^|]+%|%s*(.+)$")
	if stripped then
		return stripped
	end
	return title
end)

local islist = function(t)
	if type(t) ~= "table" then
		return false
	end

	local i = 1
	for _ in pairs(t) do
		if t[i] == nil then
			return false
		end
		i = i + 1
	end

	return true
end

local function merge(l, r)
	assert(type(l) == "table", "First argument is a table")
	assert(type(r) == "table", "Second argument is a table")
	assert(not islist(l), "First argument is not a list")
	assert(not islist(r), "Second argument is not a list")

	local res = {}
	for k, v in pairs(l) do
		res[k] = v
	end

	for k, v in pairs(r) do
		if type(res[k]) == "table" and type(v) == "table" and not islist(res[k]) and not islist(v) then
			res[k] = merge(res[k], v)
		else
			res[k] = v
		end
	end

	return res
end

config = merge(baseConfig, config)

return config
