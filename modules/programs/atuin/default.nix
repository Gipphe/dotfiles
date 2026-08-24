{
  util,
  inputs,
  config,
  pkgs,
  ...
}:
let
  module = (inputs.wlib.lib.evalModule ./wrapper.nix).config.eval {
    inherit pkgs;
    stateDir = "${config.xdg.stateHome}/atuin";
    dataDir = "${config.xdg.dataHome}/atuin";
    logDir = "${config.xdg.stateHome}/atuin/logs";
    settings = {
      style = "compact";
      search_mode_shell_up_key_binding = "prefix";
      enter_accept = true;
      filter_mode = "directory";
      keymap_mode = "vim-insert";
      keymap_cursor = {
        emacs = "blink-bar";
        vim_insert = "blink-bar";
        vim_normal = "blink-block";
      };
    };
  };
in
util.mkProgram {
  name = "atuin";
  homeManager = {
    home.packages = [ module.config.wrapper ];
    programs.fish = module.config.passthru.fish;
    programs.bash = module.config.passthru.bash;
    programs.zsh = module.config.passthru.zsh;
    programs.nushell = module.config.passthru.nushell;
  };
}
