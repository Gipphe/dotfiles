{ inputs, ... }:
{
  den.aspects.programs.atuin = {
    homeManager =
      { config, pkgs, ... }:
      let
        module = (inputs.wrappers.lib.evalModule ./_wrapper.nix).config.eval {
          inherit pkgs;
          stateDir = "${config.xdg.stateHome}/atuin";
          dataDir = "${config.xdg.dataHome}/atuin";
          logDir = "${config.xdg.stateHome}/atuin/logs";
          settings = {
            style = "compact";
            search_mode_shell_up_key_binding = "prefix";
            enter_accept = true;
            filter_mode = "session-preload";
            keymap_mode = "vim-insert";
            keymap_cursor = {
              emacs = "blink-bar";
              vim_insert = "blink-bar";
              vim_normal = "blink-block";
            };
          };
        };
      in
      {
        home.packages = [ module.config.wrapper ];
        programs = {
          fish = module.config.passthru.fish;
          bash = module.config.passthru.bash;
          zsh = module.config.passthru.zsh;
          nushell = module.config.passthru.nushell;
        };
      };
  };
}
