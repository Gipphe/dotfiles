{ pkgs, ... }:
let
  inherit (import ../util.nix) kv;
in
{
  programs.nixvim = {
    extraPackages = [ pkgs.vimPlugins.nui-nvim ];
    plugins = {
      noice = {
        enable = true;

        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
        };

        routes = [
          {
            filter = {
              event = "msg_show";
              any = [
                { find = "%d+L; %d+B"; }
                { find = "; after #%d+"; }
                { find = "; before #%d+"; }
              ];
            };
            view = "mini";
          }
        ];

        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
        };
      };
      which-key = {
        registrations = {
          "<leader>sn" = "+noice";
        };
      };
    };

    keymaps = [
      (kv "c" "<S-Enter>" ''function() require("noice").redirect(vim.fn.getcmdline()) end'' {
        desc = "Redirect Cmdline";
      })
      (kv "n" "<leader>snl" ''function() require("noice").cmd("last") end'' {
        desc = "Noice Last Message";
      })
      (kv "n" "<leader>snh" ''function() require("noice").cmd("history") end'' {
        desc = "Noice History";
      })
      (kv "n" "<leader>sna" ''function() require("noice").cmd("all") end'' { desc = "Noice All"; })
      (kv "n" "<leader>snd" ''function() require("noice").cmd("dismiss") end'' { desc = "Dismiss All"; })
      (kv
        [
          "i"
          "n"
          "s"
        ]
        "<c-f>"
        ''function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end''
        {
          expr = true;
          desc = "Scroll Forward";
        }
      )
      (kv
        [
          "i"
          "n"
          "s"
        ]
        "<c-b>"
        ''function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end''
        {
          expr = true;
          desc = "Scroll Backward";
        }
      )
    ];
  };
}
