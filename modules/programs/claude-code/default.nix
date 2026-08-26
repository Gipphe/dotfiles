{ inputs, util, ... }:
util.mkProgram {
  name = "claude-code";
  homeManager = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "claude-code";
        value = inputs.wlib.lib.wrapperModules.claude-code;
      })
      ./skills
    ];
    wrappers.claude-code = {
      enable = true;
      settings = {
        alwaysThinkingEnabled = true;
      };
    };
  };
}
