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
        search_mode_shell_up_key_binding = "prefix";
        enter_accept = true;
        keymap_mode = "vim-insert";
        keymap_cursor = {
          emacs = "blink-bar";
          vim_insert = "blink-bar";
          vim_normal = "blink-block";
        };
      };
    };
  };
}
