{
  util,
  pkgs,
  lib,
  ...
}:
let
  skills = lib.pipe ./skills [
    builtins.readDir
    (lib.filterAttrs (_: t: t == "directory"))
    builtins.attrNames
    (map (s: {
      name = ".claude/skills/${s}";
      value = {
        source = pkgs.callPackage ./skills/${s} { };
      };
    }))
    builtins.listToAttrs
  ];
in
util.mkProgram {
  name = "claude-code";
  hm = {
    home = {
      packages = [ pkgs.claude-code ];
      file = skills // {
        ".claude/settings.json".text = builtins.toJSON {
          alwaysThinkingEnabled = true;
        };
      };
    };
  };
}
