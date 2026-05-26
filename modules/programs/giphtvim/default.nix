{
  pkgs,
  util,
  inputs,
  flags,
  ...
}:
let
  giphtvim = inputs.giphtvim.packages.${pkgs.stdenv.hostPlatform.system};
in
util.mkProgram {
  name = "giphtvim";
  homeManager = {
    home.packages = if flags.isNixOnDroid then [ giphtvim.droid ] else [ giphtvim.neovim ];
    home.sessionVariables.EDITOR = "nvim";
    programs.fish.shellAbbrs.vim = "nvim";
  };
}
