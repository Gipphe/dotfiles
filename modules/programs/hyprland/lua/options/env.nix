{
  lib,
  config,
  util,
  ...
}:
let
  cfg = config.gipphe.programs.hyprland;
  toLua = lib.generators.toLua { };
  toEnv = name: val: /* lua */ ''
    hl.env(${toLua name}, ${toLua val})
  '';
in
util.mkModule {
  options.gipphe.programs.hyprland.settings.env = lib.mkOption {
    description = "Environment variables";
    default = { };
    example = {
      GTK_THEME = "Nord";
    };
    type = with lib.types; attrsOf (either luaInline str);
  };
  hm = {
    gipphe.programs.hyprland.settings.rendered = lib.mkIf (cfg.settings.env != { }) ''
      ${builtins.concatStringsSep "\n" (lib.mapAttrsToList toEnv cfg.settings.env)}
    '';
  };
}
