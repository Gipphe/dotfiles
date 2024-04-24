{
  programs.nixvim.extraConfigLuaPre = ''
    -- Shamelessly stolen from LazyVim 
    -- See https://github.com/LazyVim/LazyVim/blob/bb36f71b77d8e15788a5b62c82a1c9ec7b209e49/lua/lazyvim/util/root.lua

    ---@class lazyvim.util.root
    ---@overload fun(): string
    local Root = setmetatable({}, {
      __call = function(m)
        return m.get()
      end,
    })

    ---@class LazyRoot
    ---@field paths string[]
    ---@field spec LazyRootSpec

    ---@alias LazyRootFn fun(buf: number): (string|string[])

    ---@alias LazyRootSpec string|string[]|LazyRootFn

    ---@type LazyRootSpec[]
    Root.spec = { "lsp", { ".git", "lua" }, "cwd" }

    Root.detectors = {}

    function Root.detectors.cwd()
      return { vim.uv.cwd() }
    end

    function Root.detectors.lsp(buf)
      local bufpath = Root.bufpath(buf)
      if not bufpath then
        return {}
      end
      local roots = {} ---@type string[]
      for _, client in pairs(Lsp.get_clients({ bufnr = buf })) do
        -- only check workspace folders, since we're not interested in clients
        -- running in single file mode
        local workspace = client.config.workspace_folders
        for _, ws in pairs(workspace or {}) do
          roots[#roots + 1] = vim.uri_to_fname(ws.uri)
        end
      end
      return vim.tbl_filter(function(path)
        path = Util.norm(path)
        return path and bufpath:find(path, 1, true) == 1
      end, roots)
    end

    ---@param patterns string[]|string
    function Root.detectors.pattern(buf, patterns)
      patterns = type(patterns) == "string" and { patterns } or patterns
      local path = Root.bufpath(buf) or vim.uv.cwd()
      local pattern = vim.fs.find(patterns, { path = path, upward = true })[1]
      return pattern and { vim.fs.dirname(pattern) } or {}
    end

    function Root.bufpath(buf)
      return Root.realpath(vim.api.nvim_buf_get_name(assert(buf)))
    end

    function Root.cwd()
      return Root.realpath(vim.uv.cwd()) or ""
    end

    function Root.realpath(path)
      if path == "" or path == nil then
        return nil
      end
      path = vim.uv.fs_realpath(path) or path
      return Util.norm(path)
    end

    ---@param spec LazyRootSpec
    ---@return LazyRootFn
    function Root.resolve(spec)
      if Root.detectors[spec] then
        return Root.detectors[spec]
      elseif type(spec) == "function" then
        return spec
      end
      return function(buf)
        return Root.detectors.pattern(buf, spec)
      end
    end

    ---@param opts? { buf?: number, spec?: LazyRootSpec[], all?: boolean }
    function Root.detect(opts)
      opts = opts or {}
      opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or Root.spec
      opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

      local ret = {} ---@type LazyRoot[]
      for _, spec in ipairs(opts.spec) do
        local paths = Root.resolve(spec)(opts.buf)
        paths = paths or {}
        paths = type(paths) == "table" and paths or { paths }
        local roots = {} ---@type string[]
        for _, p in ipairs(paths) do
          local pp = Root.realpath(p)
          if pp and not vim.tbl_contains(roots, pp) then
            roots[#roots + 1] = pp
          end
        end
        table.sort(roots, function(a, b)
          return #a > #b
        end)
        if #roots > 0 then
          ret[#ret + 1] = { spec = spec, paths = roots }
          if opts.all == false then
            break
          end
        end
      end
      return ret
    end

    ---@type table<number, string>
    Root.cache = {}

    -- returns the root directory based on:
    -- * lsp workspace folders
    -- * lsp root_dir
    -- * root pattern of filename of the current buffer
    -- * root pattern of cwd
    ---@param opts? {normalize?:boolean}
    ---@return string
    function Root.get(opts)
      local buf = vim.api.nvim_get_current_buf()
      local ret = Root.cache[buf]
      if not ret then
        local roots = Root.detect({ all = false })
        ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
        Root.cache[buf] = ret
      end
      if opts and opts.normalize then
        return ret
      end
      return Util.is_win() and ret:gsub("/", "\\") or ret
    end
  '';
}
