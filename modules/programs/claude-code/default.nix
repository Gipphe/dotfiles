{ inputs, util, ... }:
util.mkProgram {
  name = "claude-code";
  homeManager = {
    imports = [
      (inputs.wrappers.lib.getInstallModule {
        name = "claude-code";
        value = inputs.wrappers.lib.wrapperModules.claude-code;
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
