{ pkgs, ... }:
{
  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-jjdescription";
      src = pkgs.fetchFromGitHub {
        owner = "avm99963";
        repo = "vim-jjdescription";
        rev = "ca14325202f3cd894d01ba833451017624249222";
        hash = "";
      };
    })
  ];
}
