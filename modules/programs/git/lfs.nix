{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.git.lfs;
in
util.mkToggledModule [ "programs" "git" ] {
  name = "lfs";
  options.gipphe.programs.git.lfs = {
    skipSmudge = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Skip smudge";
    };
  };
  hm = {
    home.packages = [ pkgs.git-lfs ];
    wrappers.git = {
      settings = {
        filter.lfs =
          let
            skipArg = lib.optional cfg.skipSmudge "--skip";
          in
          {
            clean = "git-lfs clean -- %f";
            process = concatStringsSep " " ([
              "git-lfs"
              "filter-process"
            ]);
          };
      };
    };
  };
}
