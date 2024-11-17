{
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "logseq";
  hm.home.packages = [ pkgs.logseq ];
  system-all.nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];
}
