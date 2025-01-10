{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (import ../util.nix) kv;
in
{
  options.gipphe.programs.nixvim.plugins.telescope-jj.enable =
    lib.mkEnableOption "telescope-jj plugin";
  config.programs.nixvim = lib.mkIf config.gipphe.programs.nixvim.plugins.telescope-jj.enable {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "telescope-jj.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "zschreur";
          repo = "telescope-jj.nvim";
          rev = "9527e39f30eded7950ca127698422ec412d633c4";
          hash = "sha256-hAXW5IbGs2Z46o/1DEO+Y0HhWu/wduzOLk1JWcNO7EU=";
        };
      })
    ];
    extraConfigLua = ''
      function setup_telescope_jj()
        local telescope = require('telescope')
        telescope.load_extension("jj")
      end
    '';
    keymaps = [
      (kv "n" "<leader>tjj" # lua
        ''
          function(opts)
            local telescope = require("telescope")
            local jj_pick_status, jj_res = pcall(telescope.extensions.jj.files, opts)
            if jj_pick_status then
              return
            end

            local builtin = require("telescope.builtin")
            local git_files_status, git_res = pcall(builtin.git_files, opts)
            if not git_files_status then
              error("Could not launch jj/git files: \n" .. jj_res .. "\n" .. git_res)
            end
          end
        ''
        { desc = "Find files (jj)"; }
      )
      (kv "n" "<leader>tjc" ''function(opts) require('telescope').extensions.jj.conflicts(opts) end'' {
        desc = "Find conflicts (jj)";
      })
      (kv "n" "<leader>tjd" "function(opts) require('telescope').extensions.jj.diff(opts) end" {
        desc = "Find files with differences (jj)";
      })
    ];
  };
}
