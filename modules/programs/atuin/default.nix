{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkProgram {
  name = "atuin";
  hm.programs.atuin = {
    enable = true;
    # TODO: Replace with upstream once atuin 18.10.0 is in `nixos-unstable`.
    package = inputs.atuin.packages.${pkgs.system}.atuin;
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
}
