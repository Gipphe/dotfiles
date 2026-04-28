{
  lib,
  util,
  config,
  ...
}:
let
  toLua = lib.generators.toLua { };
  cfg = config.gipphe.programs.hyprland;
in
util.mkModule {
  options.gipphe.programs.hyprland.settings.config = lib.mkOption {
    type =
      with lib.types;
      let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "Hyprland configuration value";
          };
      in
      valueType;
    default = { };
    description = ''
      Hyprland configuration written in Nix. See <https://wiki.hypr.land> for
      more examples. This option will be passed to `hl.config()`. See the other
      options on [](#opt-wayland.windowManager.hyprland.settings) for other
      configuration options.
    '';
    example = lib.literalExpression ''
      {
        decoration = {
          shadow_offset = "0 5";
          "col.shadow" = "rgba(00000099)";
        };
      }
    '';
  };
  hm = {
    gipphe.programs.hyprland.settings.rendered = lib.mkIf (cfg.settings.config != { }) (
      lib.mkBefore ''
        hl.config(${toLua cfg.settings.config})
      ''
    );
  };
}
