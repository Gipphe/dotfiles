local M = {}

---Run command and capture output.
---@param cmd string
---@return string|nil
---@diagnostic disable-next-line: unused-local, unused-function
function M.capture(cmd)
  local handle = io.popen(cmd)
  if handle == nil then
    return nil
  end
  local result = handle:read '*a'
  handle:close()
  return result
end

---Returns `true` if the current OS is MacOS. Returns `false` otherwise.
---@return boolean
function M.is_mac()
  ---@diagnostic disable-next-line: undefined-field
  return vim.fn.has 'mac' == 1
end
---Returns `true` if the current OS is a Linux distro. Returns `false` otherwise.
---@return boolean
function M.is_linux()
  ---@diagnostic disable-next-line: undefined-field
  return vim.fn.has 'linux' == 1
end

---Returns `true` if the current OS is a Windows. Returns `false` otherwise.
---@return boolean
function M.is_windows()
  ---@diagnostic disable-next-line: undefined-field
  return vim.fn.has 'win32' == 1
end

---Returns the hostname of the machine using libuv.
---@return string
function M.hostname()
  ---@diagnostic disable-next-line: undefined-field
  return vim.uv.os_gethostname()
end

---Returns the current working directory.
---@return string
function M.get_current_dir()
  local cwd = vim.fn.expand '%:p:h:~:.'
  local x, _ = cwd:gsub('^oil://', '')
  return x
end

function M.close_floating_windows()
  local inactive_floating_wins = vim.fn.filter(vim.api.nvim_list_wins(), function(_, v)
    local buf = vim.api.nvim_win_get_buf(v)
    local file_type = vim.api.nvim_get_option_value('filetype', { buf = buf })
    return vim.api.nvim_win_get_config(v).relative ~= '' and v ~= vim.api.nvim_get_current_win() and file_type ~= 'hydra_hint'
  end)

  for _, w in ipairs(inactive_floating_wins) do
    pcall(vim.api.nvim_win_close, w, false)
  end
end

function thunk(f, outerArgs)
  return function(...)
    f(table.unpack(vim.fn.extendnew(outerArgs, arg)))
  end
end

function M.thunk(f, ...)
  return thunk(f, arg)
end

M.icons = {
  misc = {
    dots = '󰇘',
  },
  dap = {
    Stopped = {
      '󰁕 ',
      'DiagnosticWarn',
      'DapStoppedLine',
    },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = {
      ' ',
      'DiagnosticError',
    },
    LogPoint = '.>',
  },
  diagnostics = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
  },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
  },
  kinds = {
    Array = ' ',
    Boolean = '󰨙 ',
    Class = ' ',
    Codeium = '󰘦 ',
    Color = ' ',
    Control = ' ',
    Collapsed = ' ',
    Constant = '󰏿 ',
    Constructor = ' ',
    Copilot = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Event = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = '󰊕 ',
    Interface = ' ',
    Key = ' ',
    Keyword = ' ',
    Method = '󰊕 ',
    Module = ' ',
    Namespace = '󰦮 ',
    Null = ' ',
    Number = '󰎠 ',
    Object = ' ',
    Operator = ' ',
    Package = ' ',
    Property = ' ',
    Reference = ' ',
    Snippet = ' ',
    String = ' ',
    Struct = '󰆼 ',
    TabNine = '󰏚 ',
    Text = ' ',
    TypeParameter = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = '󰀫 ',
  },
}

return M
