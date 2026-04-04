{
  inputs,
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
    imports = [
      (inputs.wlib.lib.mkInstallModule {
        loc = [
          "home"
          "packages"
        ];
        name = "claude-code";
        value = inputs.wlib.lib.wrapperModules.claude-code;
      })
    ];
    wrappers.claude-code = {
      enable = true;
      settings = {
        alwaysThinkingEnabled = true;
      };
    };
    home.file = skills;
  };
}
