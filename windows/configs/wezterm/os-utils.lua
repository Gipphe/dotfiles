local M = {}

function M.isWindows()
  return os.getenv("COMSPEC") ~= nil and os.getenv("USERPROFILE") ~= nil
end

return M
