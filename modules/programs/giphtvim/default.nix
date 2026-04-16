{
  util,
  lib,
  inputs,
  flags,
  ...
}:
util.mkProgram {
  name = "giphtvim";
  hm = {
    imports = [ inputs.giphtvim.homeModules.default ];
    config = {
      home.sessionVariables.EDITOR = "nvim";
      programs.fish.shellAbbrs.vim = "nvim";
      nvim = {
        enable = true;
        packageNames = lib.mkIf flags.isNixOnDroid [ "droid" ];
      };
    };
  };
}
