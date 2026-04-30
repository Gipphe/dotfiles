{
  inputs,
  util,
  pkgs,
  ...
}:
let
  skills = {
    ".claude/skills/build-hs".source = pkgs.callPackage ./skills/build-hs { };
    ".claude/skills/cardano-search".source = pkgs.callPackage ./skills/cardano-search { };
    ".claude/skills/codebase-visualizer".source = pkgs.callPackage ./skills/codebase-visualizer { };
    ".claude/skills/commit".source = pkgs.callPackage ./skills/commit { };
    ".claude/skills/tricorder".source = pkgs.callPackage ./skills/tricorder {
      inherit (inputs) tricorder;
    };
  };
in
util.mkProgram {
  name = "claude-code";
  hm = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
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
