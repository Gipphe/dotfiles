{
  inputs,
  util,
  pkgs,
  ...
}:
let
  module = inputs.wlib.wrappers.claude-code.wrap {
    inherit pkgs;
    settings = {
      alwaysThinkingEnabled = true;
    };
  };
in
util.mkProgram {
  name = "claude-code";
  homeManager = {
    imports = [ ./skills ];
    home.packages = [ module ];
    wrappers.claude-code = {
      enable = true;
      settings = {
        alwaysThinkingEnabled = true;
      };
    };
  };
}
