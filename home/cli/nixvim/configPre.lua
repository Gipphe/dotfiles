      local Set = {}

      function Set.union(a, b)
        Set.verify(a)
        Set.verify(b)
        local res = Set.new()
        for k in pairs(a) do res[k] = true end
        for k in pairs(b) do res[k] = true end
        return res
      end

      function Set.intersection(a, b)
        Set.verify(a)
        Set.verify(b)
        local res = Set.new()
        for k in pairs(a) do
          res[k] = b[k]
        end
        return res
      end

      function Set.empty()
        local set = {}
        setmetatable(set, Set.mt)
        return set
      end

      function Set.contains(set, key)
        Set.verify(set)
        return set[key] ~= nil
      end

      function Set.verify(a)
        if getmetatable(a) ~= Set.mt then
          error("not a set")
        end
      end

      function Set.tostring(set)
        local s = "{"
        local sep = ""
        for e in pairs(set) do
          s = s .. sep .. e
          sep = ", "
        end
        return s .. "}"
      end

      function Set.print(set)
        print(Set.tostring(set))
      end

      Set.mt = {}
      Set.mt.__add = Set.union
      Set.mt.__mul = Set.intersection

      local utils = {}
      -- utils.skip_foldexpr = {}
      -- local skip_check = assert(vim.uv.new_check())
      -- function utils.foldexpr()
      --   local buf = vim.api.nvim_get_current_buf()

      --   -- Still in the same tick and no parser
      --   if utils.skip_foldexpr[buf] then
      --     return "0"
      --   end

      --   -- Don't use treesitter folds for non-file buffers
      --   if vim.bo[buf].buftype ~= "" then
      --     return "0"
      --   end

      --   -- As long as we don't have a filetype, don't bother
      --   -- checking if treesitter is availale (it won't)
      --   if vim.bo[buf].filetype == "" then
      --     return "0"
      --   end

      --   local ok = pcall(vim.treesitter.get_parser, buf)
      --   if ok then
      --     return vim.treesitter.foldexpr()
      --   end

      --   -- no parser available, so mark it as skip
      --   -- in the next tick, all skip marks will be reset
      --   utils.skip_foldexpr[buf] = true
      --   skip_check:start(function()
      --     utils.skip_foldexpr = {}
      --     skip_check:stop()
      --   end)
      --   return "0"

      ---@return {fg?:string}?
      function utils.fg(name)
        local color = utils.color(name)
        return color and { fg = color } or nil
      end

      ---@param name string
      ---@param bg? boolean
      ---@return string?
      function utils.color(name, bg)
        ---@type {foreground?:number}?
        ---@diagnostic disable-next-line: deprecated
        local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name, link = false })
          or vim.api.nvim_get_hl_by_name(name, true)
        ---@diagnostic disable-next-line: undefined-field
        ---@type string?
        local color = nil
        if hl then
          if bg then
            color = hl.bg or hl.background
          else
            color = hl.fg or hl.foreground
          end
        end
        return color and string.format("#%06x", color) or nil
      end     -- end

      function utils.foldtext()
        local ok = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
        local ret = ok and vim.treesitter.foldtext and vim.treesitter.foldtext()
        if not ret or type(ret) == "string" then
          ret = { { vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1], {} } }
        end
        table.insert(ret, { " ${icons.misc.dots}" })

        if not vim.treesitter.foldtext then
          return table.concat(
            vim.tbl_map(function(line)
              return line[1]
            end, ret),
            " "
          )
        end
        return ret
      end

      function utils.get_signs(buf, lnum)
        -- Get regular signs
        ---@type Sign[]
        local signs = {}

        if vim.fn.has("nvim-0.10") == 0 then
          -- Only needed for Neovim <0.10
          -- Newer versions include legacy signs in nvim_buf_get_extmarks
          for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs) do
            local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as Sign]]
            if ret then
              ret.priority = sign.priority
              signs[#signs + 1] = ret
            end
          end
        end

        -- Get extmark signs
        local extmarks = vim.api.nvim_buf_get_extmarks(
          buf,
          -1,
          { lnum - 1, 0 },
          { lnum - 1, -1 },
          { details = true, type = "sign" }
        )
        for _, extmark in pairs(extmarks) do
          signs[#signs + 1] = {
            name = extmark[4].sign_hl_group or "",
            text = extmark[4].sign_text,
            texthl = extmark[4].sign_hl_group,
            priority = extmark[4].priority,
          }
        end

        -- Sort by priority
        table.sort(signs, function(a, b)
          return (a.priority or 0) < (b.priority or 0)
        end)

        return signs
      end

      ---@param sign? Sign
      ---@param len? number
      function utils.icon(sign, len)
        sign = sign or {}
        len = len or 2
        local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
        text = text .. string.rep(" ", len - vim.fn.strchars(text))
        return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
      end

      function utils.statuscolumn()
        local win = vim.g.statusline_winid
        local buf = vim.api.nvim_win_get_buf(win)
        local is_file = vim.bo[buf].buftype == ""
        local show_signs = vim.wo[win].signcolumn ~= "no"

        local components = { "", "", "" } -- left, middle, right

        if show_signs then
          ---@type Sign?,Sign?,Sign?
          local left, right, fold
          for _, s in ipairs(utils.get_signs(buf, vim.v.lnum)) do
            if s.name and (s.name:find("GitSign") or s.name:find("MiniDiffSign")) then
              right = s
            else
              left = s
            end
          end
          if vim.v.virtnum ~= 0 then
            left = nil
          end
          vim.api.nvim_win_call(win, function()
            if vim.fn.foldclosed(vim.v.lnum) >= 0 then
              fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded" }
            end
          end)
          -- Left: mark or non-git sign
          components[1] = utils.icon(utils.get_mark(buf, vim.v.lnum) or left)
          -- Right: fold icon or git sign (only if file)
          components[3] = is_file and utils.icon(fold or right) or ""
        end

        -- Numbers in Neovim are weird
        -- They show when either number or relativenumber is true
        local is_num = vim.wo[win].number
        local is_relnum = vim.wo[win].relativenumber
        if (is_num or is_relnum) and vim.v.virtnum == 0 then
          if vim.v.relnum == 0 then
            components[2] = is_num and "%l" or "%r" -- the current line
          else
            components[2] = is_relnum and "%r" or "%l" -- other lines
          end
          components[2] = "%=" .. components[2] .. " " -- right align
        end

        if vim.v.virtnum ~= 0 then
          components[2] = "%= "
        end

        return table.concat(components, "")
      end

      ---@return Sign?
      ---@param buf number
      ---@param lnum number
      function utils.get_mark(buf, lnum)
        local marks = vim.fn.getmarklist(buf)
        vim.list_extend(marks, vim.fn.getmarklist())
        for _, mark in ipairs(marks) do
          if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match("[a-zA-Z]") then
            return { text = mark.mark:sub(2), texthl = "DiagnosticHint" }
          end
        end
      end

      _G.utils = utils
