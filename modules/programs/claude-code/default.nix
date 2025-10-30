{ util, pkgs, ... }:
util.mkProgram {
  name = "claude-code";
  hm = {
    home = {
      packages = [ pkgs.claude-code ];
      file = {
        ".claude/commands".source = ./commands;
        ".claude/settings.json".text = builtins.toJSON {
          alwaysThinkingEnabled = true;
        };
      };
    };
  };
}
