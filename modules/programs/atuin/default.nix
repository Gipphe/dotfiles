{
  util,
  inputs,
  config,
  ...
}:
util.mkProgram {
  name = "atuin";
  hm = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "atuin";
        value = ./wrapper.nix;
      })
    ];
    wrappers.atuin = {
      enable = true;
      stateDir = "${config.xdg.stateHome}/atuin";
      dataDir = "${config.xdg.dataHome}/atuin";
      logDir = "${config.xdg.stateHome}/atuin/logs";
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
    programs.fish = config.wrappers.atuin.passthru.fish;
    programs.bash = config.wrappers.atuin.passthru.bash;
    programs.zsh = config.wrappers.atuin.passthru.zsh;
    programs.nushell = config.wrappers.atuin.passthru.nushell;
  };
}
