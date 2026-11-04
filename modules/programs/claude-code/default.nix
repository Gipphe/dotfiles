{ inputs, den, ... }: {
  den.aspects.programs.claude-code = {
    includes = [
      den.aspects.programs.claude-code.skills._
      (den.batteries.unfree [ "claude-code" ])
    ];
    homeManager =
      { pkgs, ... }:
      let
        module = inputs.wrappers.wrappers.claude-code.wrap {
          inherit pkgs;
          settings = {
            alwaysThinkingEnabled = true;
          };
        };
      in
      {
        home.packages = [ module ];
      };
  };
}
