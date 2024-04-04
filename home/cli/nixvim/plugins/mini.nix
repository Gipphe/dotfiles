{ ... }:
{
  programs.nixvim = {
    keymaps = [
      {
        key = "<leader>up";
        action = ''
          function()
            vim.g.minipairs_disable = not vim.g.minipairs_disable
            if vim.g.minipairs_disable then
              print("Disabled auto pairs")
            else
              print("Enable auto pairs")
            end
          end
        '';
        options = {
          desc = "Toggle Auto Pairs";
        };
      }
    ];
    plugins.mini = {
      enable = true;
      modules = {
        # Configured in `mini.ai.nix`
        # ai = {}
        indentscope = {
          symbol = "|";
          options = {
            try_as_border = true;
          };
        };
        pairs = { };
        bufremove.enable = true;
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
      };
    };
  };
}
