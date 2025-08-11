{
  util,
  pkgs,
  config,
  ...
}:
util.mkProgram {
  name = "bat";
  hm = {
    home.packages = [
      (pkgs.writeShellScriptBin "batman" ''
        ${pkgs.man-db}/bin/man "$@" | ${pkgs.unixtools.col}/bin/col -bx | ${config.programs.bat.package}/bin/bat -l man -p
      '')
    ];
    programs = {
      fish.shellAbbrs.cat = "bat";
      bat.enable = true;
    };
  };
}
