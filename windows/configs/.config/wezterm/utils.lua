local M = {}

--- Deeply merge two tables, returning a new table with the contents from both tables. `mode` defines what happens with identical keys:
--- - `'error'` raises an exception
--- - `'keep'` keeps the value from the first table
--- - `'force'` keeps the value from the second table
---@param t1 table
---@param t2 table
---@param mode 'error'|'keep'|'force'|nil Defaults to `'force'`
function M.tbl_deep_extend(t1, t2, mode)
	if type(t1) ~= "table" or type(t2) ~= "table" then
		error("tbl_deep_extend only works on tables", 2)
	end

	if mode == nil then
		mode = "force"
	else
		local modes = { "force", "keep", "error" }
		local isValidMode = M.any(modes, function(x)
			return x == mode
		end)
		if not isValidMode then
			error("Invalid mode: " .. mode, 2)
		end
	end

	local res = {}
	for k1, v1 in pairs(t1) do
		res[k1] = v1
	end
	for k2, v2 in pairs(t2) do
		local v1 = res[k2]
		if type(v1) == "table" and type(v2) == "table" then
			res[k2] = M.tbl_deep_extend(v1, v2)
		elseif mode == "force" then
			res[k2] = v2
		elseif mode == "keep" then
			res[k2] = v1
		else
			error("Found key collision: " .. k2)
		end
	end

	return res
end

--- Deeply merge two tables, keeping the second table's value in case of
--- a collision. Merges nested tables in the same fashion.
---
--- Returns `false` for empty tables.
---@param table table
---@param predicate fun(x: any): boolean
---@return boolean
function M.any(table, predicate)
	for _, v in ipairs(table) do
		if predicate(v) then
			return true
		end
	end
	return false
end

--- Returns `true` if ran on Windows. `false` otherwise.
---@return boolean
function M.isWindows()
	return os.getenv("COMSPEC") ~= nil and os.getenv("USERPROFILE") ~= nil
end

--- Returns `true` if ran on Linux. `false` otherwise.
---@return boolean
function M.isLinux()
	return not M.isWindows()
end

return M
