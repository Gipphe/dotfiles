local M = {}

function M.pnpm_workspaces()
  local items = {}
  local longest_name = 0
  local workspaces = require('pnpm').list_workspace_packages()
  if workspaces == nil then
    vim.notify('No pnpm workspaces found', 'WARN')
    return
  end
  for i, workspace in ipairs(workspaces) do
    table.insert(items, {
      idx = i,
      score = i,
      text = workspace.path,
      name = workspace.name,
    })
    longest_name = math.max(longest_name, #workspace.name)
  end
  return require('snacks').picker {
    items = items,
    format = function(item)
      local ret = {}
      ret[#ret + 1] = { ('%-' .. longest_name .. 's'):format(item.name), 'SnacksPickerLabel' }
      ret[#ret + 1] = { item.text, 'SnacksPickerComment' }
      return ret
    end,
    confirm = function(picker, item)
      picker:close()
      vim.cmd(('Oil %s'):format(item.path))
    end,
  }
end

return M
