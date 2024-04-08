{ config, ... }:
let
  inherit (config.nixvim) helpers;
  icons = import ../icons.nix;
in
{
  programs.nixvim.plugins.lualine = {
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
}
