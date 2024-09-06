let
  inherit (import ../util.nix) kv k;
in
{
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
      settings = {
        use_diagnostic_signs = true;
      };
    };
    keymaps = [
      (k "n" "<leader>xx" "<cmd>TroubleToggle document_diagnostics<cr>" {
        desc = "Document Diagnostics (Trouble)";
      })
      (k "n" "<leader>xX" "<cmd>TroubleToggle workspace_diagnostics<cr>" {
        desc = "Workspace Diagnostics (Trouble)";
      })
      (k "n" "<leader>xL" "<cmd>TroubleToggle loclist<cr>" { desc = "Location List (Trouble)"; })
      (k "n" "<leader>xQ" "<cmd>TroubleToggle quickfix<cr>" { desc = "Quickfix List (Trouble)"; })
      (kv "n" "[q" ''
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end
      '' { desc = "Previous Trouble/Quickfix Item"; })
      (kv "n" "]q" ''
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end
      '' { desc = "Next Trouble/Quickfix Item"; })
    ];
  };
}
