{ den, inputs, ... }: {
  den.aspects.programs.btop.homeManager =
    { user }:
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      module = inputs.wrappers.wrappers.btop.eval {
        inherit pkgs;
        settings = {
          color_theme = "stylix";
        };
        themes = lib.mkIf (user.hasAspect den.aspects.environment.stylix) {
          stylix = config.programs.btop.themes.stylix;
        };
      };
    in
    {
      home.packages = [ module.config.wrapper ];
    };
}
