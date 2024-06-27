{ config, ... }:
let
  inherit (config.nixvim) helpers;
  icons = import ../icons.nix;
in
{
  programs.nixvim = {
    extraConfigLuaPre = ''
      local Lualine = {}

      ---@param component any
      ---@param text string
      ---@param hl_group? string
      ---@return string
      function Lualine.format(component, text, hl_group)
        if not hl_group or hl_group == "" then
          return text
        end
        ---@type table<string, string>
        component.hl_cache = component.hl_cache or {}
        local lualine_hl_group = component.hl_cache[hl_group]
        if not lualine_hl_group then
          local utils = require("lualine.utils.utils")
          ---@type string[]
          local gui = vim.tbl_filter(function(x)
            return x
          end, {
            utils.extract_highlight_colors(hl_group, "bold") and "bold",
            utils.extract_highlight_colors(hl_group, "italic") and "italic",
          })

          lualine_hl_group = component:create_hl({
            fg = utils.extract_highlight_colors(hl_group, "fg"),
            gui = #gui > 0 and table.concat(gui, ",") or nil,
          }, "LV_" .. hl_group) --[[@as string]]
          component.hl_cache[hl_group] = lualine_hl_group
        end
        return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
      end

      function Lualine.pretty_path(opts)
        opts = vim.tbl_extend("force", {
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
        }, opts or {})

        return function(self)
          local path = vim.fn.expand("%:p") --[[@as string]]

          if path == "" then
            return ""
          end

          local root = Root.get({ normalize = true })
          local cwd = Root.cwd()

          if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
            path = path:sub(#cwd + 2)
          else
            path = path:sub(#root + 2)
          end

          local sep = package.config:sub(1, 1)
          local parts = vim.split(path, "[\\/]")

          if #parts > 3 then
            parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
          end

          if opts.modified_hl and vim.bo.modified then
            parts[#parts] = parts[#parts] .. opts.modified_sign
            parts[#parts] = Lualine.format(self, parts[#parts], opts.modified_hl)
          else
            parts[#parts] = Lualine.format(self, parts[#parts], opts.filename_hl)
          end

          local dir = ""
          if #parts > 1 then
            dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
            dir = Lualine.format(self, dir .. sep, opts.directory_hl)
          end
          return dir .. parts[#parts]
        end
      end

      ---@param opts? {cwd:false, subdirectory: true, parent: true, other: true, icon?:string}
      function Lualine.root_dir(opts)
        opts = vim.tbl_extend("force", {
          cwd = false,
          subdirectory = true,
          parent = true,
          other = true,
          icon = "󱉭 ",
          color = Ui.fg("Special"),
        }, opts or {})

        local function get()
          local cwd = Root.cwd()
          local root = Root.get({ normalize = true })
          local name = vim.fs.basename(root)

          if root == cwd then
            -- root is cwd
            return opts.cwd and name
          elseif root:find(cwd, 1, true) == 1 then
            -- root is subdirectory of cwd
            return opts.subdirectory and name
          elseif cwd:find(root, 1, true) == 1 then
            -- root is parent directory of cwd
            return opts.parent and name
          else
            -- root and cwd are not related
            return opts.other and name
          end
        end

        return {
          function()
            return (opts.icon and opts.icon .. " ") .. get()
          end,
          cond = function()
            return type(get()) == "string"
          end,
          color = opts.color,
        }
      end
      local lualine_root_dir = Lualine.root_dir()
    '';

    plugins.lualine = {
      enable = true;
      globalstatus = true;
      disabledFiletypes.statusline = [
        "dashboard"
        "alpha"
        "starter"
      ];
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" ];
        lualine_c = [
          {
            name = helpers.mkRaw "lualine_root_dir[1]";
            extraConfig = {
              cond = helpers.mkRaw "lualine_root_dir.cond";
              color = helpers.mkRaw "lualine_root_dir.color";
            };
          }
          {
            name = "diagnostics";
            extraConfig = {
              symbols = {
                error = icons.diagnostics.Error;
                warn = icons.diagnostics.Warn;
                info = icons.diagnostics.Info;
                hint = icons.diagnostics.Hint;
              };
            };
          }
          {
            name = "filetype";
            extraConfig = {
              icon_only = true;
              separator = "";
            };
            padding = {
              left = 1;
              right = 0;
            };
          }
          { name = helpers.mkRaw "Lualine.pretty_path()"; }
        ];
        lualine_x = [
          {
            name = helpers.mkRaw ''function() return require("noice").api.status.command.get() end'';
            extraConfig = {
              cond = helpers.mkRaw ''function() return package.loaded["noice"] and require("noice").api.status.command.has() end'';
              color = helpers.mkRaw ''utils.fg("Statement")'';
            };
          }
          {
            name = helpers.mkRaw ''function() return require("noice").api.status.mode.get() end'';
            extraConfig = {
              cond = helpers.mkRaw ''function() return package.loaded["noice"] and require("noice").api.status.mode.has() end'';
              color = helpers.mkRaw ''utils.fg("Constant")'';
            };
          }
          {
            name = helpers.mkRaw ''function() return "  " .. require("dap").status() end'';
            extraConfig = {
              cond = helpers.mkRaw ''function() return package.loaded["dap"] and require("dap").status() ~= "" end'';
              color = helpers.mkRaw ''utils.fg("Debug")'';
            };
          }
          {
            name = "diff";
            extraConfig = {
              source = helpers.mkRaw ''
                function()
                  local gitsigns = vim.b.gitsigns_status_dict
                  if gitsigns then
                    return {
                      added = gitsigns.added,
                      modified = gitsigns.changed,
                      removed = gitsigns.removed,
                    }
                  end
                end
              '';
            };
          }
        ];
        lualine_y = [
          {
            name = "progress";
            extraConfig = {
              separator = " ";
            };
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            name = "location";
            padding = {
              left = 0;
              right = 1;
            };
          }
        ];
        lualine_z = [ { name = helpers.mkRaw ''function() return " " .. os.date("%R") end''; } ];
      };
    };
  };
}
