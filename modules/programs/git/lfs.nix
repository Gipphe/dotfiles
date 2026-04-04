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
  hm = {
    home.packages = [ pkgs.git-lfs ];
    wrappers.git = {
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
