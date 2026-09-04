{
  util,
  lib,
  pkgs,
  ...
}:
let
  lfs = lib.getExe pkgs.git-lfs;
in
util.mkToggledModule [ "programs" "git" ] {
  name = "lfs";
  homeManager = {
    home.packages = [ pkgs.git-lfs ];
    gipphe.programs.git = {
      settings = {
        filter.lfs = {
          clean = "${lfs} clean -- %f";
          process = "${lfs} filter-process";
          required = true;
          smudge = "${lfs} smudge -- %f";
        };
      };
    };
  };
}
