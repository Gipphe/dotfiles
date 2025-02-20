{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.nvf.settings.vim.tabline.bufferline;
  inherit (inputs) nvf;
  inherit (nvf.lib.nvim.binds) mkMappingOption mkKeymap;
  inherit (nvf.lib.nvim.types) luaInline mkPluginSetupOption;
  inherit (lib.generators) mkLuaInline;
  keys = cfg.mappings;
  self = import ./bufferline.nix {
    pkgs = null;
    config = null;
    inherit lib inputs;
  };
  inherit (self.options.gipphe.programs.nvf.settings.vim.tabline.bufferline) mappings;
in
{
  options.gipphe.programs.nvf.settings.vim.tabline.bufferline = {
    enable = lib.mkEnableOption "bufferline.nvim";
    setupOpts = mkPluginSetupOption "bufferline.nvim" {
      options = lib.mkOption {
        description = "Options for bufferline.nvim";
        default = { };
        type =
          with lib.types;
          submodule {
            freeformType = anything;
            options = {
              close_command = lib.mkOption {
                description = "Command to run when closing a buffer";
                type = with lib.types; either str luaInline;
                default = mkLuaInline ''
                  function(n)
                    require('mini.bufremove').delete(n, false)
                  end
                '';
              };
              right_mouse_command = lib.mkOption {
                description = "Command to run when right-clicking a buffer";
                type = with lib.types; either str luaInline;
                default = mkLuaInline ''
                  function(n)
                    require('mini.bufremove').delete(n, false)
                  end
                '';
              };
              diagnostics = lib.mkOption {
                description = "Diagnostics provider to use";
                type = lib.types.str;
                default = "nvim_lsp";
              };
              always_show_bufferline = lib.mkOption {
                description = "Show bufferline when there is only 1 buffer open";
                type = lib.types.bool;
                default = false;
              };
              diagnostics_indicator = lib.mkOption {
                description = "Command to run to produce the diagnostics indicator next to each buffer";
                type = with lib.types; either str luaInline;
                default = mkLuaInline ''
                  function(_, _, diag)
                    local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
                      .. (diag.warning and icons.diagnostics.Warn .. diag.warning or "")
                    return vim.trim(ret)
                  end
                '';
              };
            };
          };
      };
    };
    mappings = {
      togglePin = mkMappingOption "Toggle pin" "<leader>bp";
      delete = mkMappingOption "Delete current buffer" "<leader>bd";
      deleteForce = mkMappingOption "Delete current buffer (force)" "<leader>bD";
      deleteNonPinned = mkMappingOption "Delete non-pinned buffers" "<leader>bP";
      deleteOthers = mkMappingOption "Delete other buffers" "<leader>bo";
      deleteRight = mkMappingOption "Delete buffers to the right" "<leader>br";
      deleteLeft = mkMappingOption "Delete buffers to the left" "<leader>bl";
      prevBuffer = mkMappingOption "Previous buffer" "<S-h>";
      nextBuffer = mkMappingOption "Next buffer" "<S-l>";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nvf.settings.vim = {
      mini.bufremove.enable = true;
      extraPlugins = {
        bufferline-nvim = {
          package = pkgs.vimPlugins.bufferline-nvim;
          setup = ''
            require('bufferline').setup(${nvf.lib.nvim.lua.toLuaObject cfg.setupOpts})
          '';
        };
      };
      keymaps = [
        (mkKeymap "n" keys.togglePin "<Cmd>BufferLineTogglePin<CR>" {
          desc = mappings.togglePin.description;
        })
        (mkKeymap "n" keys.delete
          ''
            function()
              local bd = require('mini.bufremove').delete
              if vim.bo.modified then
                local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
                if choice == 1 then -- Yes
                  vim.cmd.write()
                  bd(0)
                elseif choice == 2 then
                  bd(0, true)
                end
              else
                bd(0)
              end
            end
          ''
          {
            desc = mappings.delete.description;
            lua = true;
          }
        )
        (mkKeymap "n" keys.deleteForce "function() require('mini.bufremove').delete(0, true) end" {
          desc = mappings.deleteForce.description;
          lua = true;
        })
        (mkKeymap "n" keys.deleteNonPinned "<Cmd>BufferLineGroupClose ungrouped<CR>" {
          desc = mappings.deleteNonPinned.description;
        })
        (mkKeymap "n" keys.deleteOthers "<Cmd>BufferLineCloseOthers<CR>" {
          desc = mappings.deleteOthers.description;
        })
        (mkKeymap "n" keys.deleteRight "<Cmd>BufferLineCloseRight<CR>" {
          desc = mappings.deleteRight.description;
        })
        (mkKeymap "n" keys.deleteLeft "<Cmd>BufferLineCloseLeft<CR>" {
          desc = mappings.deleteLeft.description;
        })
        (mkKeymap "n" keys.prevBuffer "<cmd>BufferLineCyclePrev<cr>" {
          desc = mappings.prevBuffer.description;
        })
        (mkKeymap "n" keys.nextBuffer "<cmd>BufferLineCycleNext<cr>" {
          desc = mappings.nextBuffer.description;
        })
      ];
    };
  };
}
