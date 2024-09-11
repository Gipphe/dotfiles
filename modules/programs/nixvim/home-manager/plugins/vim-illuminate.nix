{ config, ... }:
let
  inherit (import ../util.nix) kv;
  helpers = config.lib.nixvim;
  km = np: ''function() require('illuminate').goto_${np}_reference(false) end'';
in
{
  programs.nixvim = {
    plugins.illuminate = {
      delay = 200;
      largeFileCutoff = 2000;
      largeFileOverrides = {
        providers = [ "lsp" ];
      };
    };
    keymaps = [
      (kv "n" "]]" (km "next") { desc = "Next reference"; })
      (kv "n" "[[" (km "prev") { desc = "Prev reference"; })
    ];

    autoCmd = [
      {
        event = "FileType";
        callback = helpers.mkRaw ''
          function()
            local buffer = vim.api.nvim_get_current_buf()
            vim.keymap.set("n", "]]", ${km "next"}, { desc = "Next reference"; buffer = buffer })
            vim.keymap.set("n", "[[", ${km "prev"}, { desc = "Prev reference"; buffer = buffer })
          end
        '';
      }
    ];
  };
}
