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
      nvim = lib.mkMerge [
        {
          enable = true;
        }

        (lib.mkIf flags.isNixOnDroid {
          packageNames = [ "droid" ];
        })
      ];
    };
  };
}
