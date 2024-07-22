{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.gipphe.programs.dataform.enable && config.gipphe.programs.gcloud.enable) {
    programs.nixvim = {
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          name = "dataform.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "magal1337";
            repo = "dataform.nvim";
            rev = "710d68381d089b891b1f60d41af10ab06cbd008d";
            hash = "sha256-EBvcGo0SJOuGEyjU0FhsJJyXR8TkN7WkM3jpZFyyZ6A=";
          };
        })
      ];
      plugins = {
        notify.enable = true;
        telescope.enable = true;
      };
    };
  };
}
