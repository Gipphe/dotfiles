{ helpers, ... }:
{
  plugins.lualine = {
    enable = true;
    globalstatus = true;
    disableFiletypes.statusline = [
      "dashboard"
      "alpha"
      "starter"
    ];
    sections = {
      lualine_a = [ "mode" ];
      lualine_b = [ "branch" ];
      lualine_c = [
        "diagnostics"
        (
          helpers.listToUnkeyedAttrs [ "filetype" ]
          // {
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          }
        )
      ];
      lualine_x = [
        (
          helpers.listToUnkeyedAttrs [
            helpers.raw
            ''function() return require("noice").api.status.command.get() end''
          ]
          // {
            cond = helpers.raw ''function() return package.loaded["noice"] and require("noice").api.status.command.has() end'';
            color = "#f00";
          }
        )
        (
          helpers.listToUnkeyedAttrs [
            helpers.raw
            ''function() return require("noice").api.status.mode.get() end''
          ]
          // {
            cond = helpers.raw ''function() return package.loaded["noice"] and require("noice").api.status.mode.has() end'';
            color = "#0f0";
          }
        )
        (
          helpers.listToUnkeyedAttrs [
            helpers.raw
            ''function() return "  " .. require("dap").status() end''
          ]
          // {
            cond = helpers.raw ''function() return package.loaded["dap"] and require("dap").status() ~= "" end'';
            color = "#404";
          }
        )
        (
          helpers.listToUnkeyedAttrs [ "diff" ]
          // {
            source = helpers.raw ''
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
          }
        )
      ];
      lualine_y = [
        (
          helpers.listToUnkeyedAttrs [ "progress" ]
          // {
            separator = " ";
            padding = {
              left = 1;
              right = 0;
            };
          }
        )
        (
          helpers.listToUnkeyedAttrs [ "location" ]
          // {
            padding = {
              left = 0;
              right = 1;
            };
          }
        )
      ];
      lualine_z = [
        helpers.listToUnkeyedAttrs
        [
          helpers.raw
          ''function() return " " .. os.date("%R") end''
        ]
      ];
    };
  };
}
