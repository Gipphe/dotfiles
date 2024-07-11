{
  lib,
  config,
  util,
  ...
}:
util.mkModule {
  options.gipphe.programs.atuin.enable = lib.mkEnableOption "atuin";
  hm = lib.mkIf config.gipphe.programs.atuin.enable {
    programs.atuin = {
      enable = true;
      settings = {
        style = "compact";
        keymap_cursor = {
          emacs = "blink-bar";
          vim_insert = "blink-bar";
          vim_normal = "blink-block";
        };
      };
    };
  };
}
