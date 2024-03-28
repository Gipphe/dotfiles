{ ... }:
{
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
  plugins.mini.modules.pairs = { };
}
