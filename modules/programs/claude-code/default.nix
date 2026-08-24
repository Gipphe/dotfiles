{
  inputs,
  util,
  pkgs,
  ...
}:
let
  module = inputs.wrappers.wrappers.claude-code.wrap {
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
  };
}
