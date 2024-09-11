{
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "logseq";
  hm.home.packages = [ pkgs.logseq ];
}
