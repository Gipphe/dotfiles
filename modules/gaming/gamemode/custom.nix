{
  util,
  pkgs,
  lib,
  ...
}:
util.mkToggledModule [ "gaming" "gamemode" ] {
  name = "custom";
  nixos = {

    programs.gamemode.settings = {
      custom =
        let
          startStopScript =
            mode:
            util.writeNushellApplication {
              name = "gamemode-${mode}";
              runtimeInputs = with pkgs; [
                scx-loader
                power-profiles-daemon
                libnotify
              ];
              text =
                let
                  tern = ifStart: ifEnd: if mode == "start" then ifStart else ifEnd;
                in
                # nu
                ''
                  try {
                      powerprofilesctl set ${tern "performance" "balanced"}
                      scxctl switch -m ${tern "gaming" "lowlatency"}
                      notify-send -u low 'GameMode' ${tern "'Performance mode enabled'" "'Balanced mode restored'"}
                  } catch { |err|
                      notify-send -u critical 'GameMode' $"Failed to run hook: ($err.rendered)"
                      # Return error code so GameMode knows the hook failed
                      return 1
                  }
                '';
            };
        in
        {
          start = lib.getExe (startStopScript "start");
          end = lib.getExe (startStopScript "end");
        };
    };

    # security.wrappers.gamemode = {
    #   owner = "root";
    #   group = "root";
    #   source = "${lib.getExe' pkgs.gamemode "gamemoderun"}";
    #   capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
    # };

    # Allow users in gamemode group to manage schedulers via scx_loader
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
           action.id == "org.scx.loader.manage-schedulers" &&
           subject.isInGroup("gamemode")
        ) {
          return polkit.Result.YES;
        }
      });
    '';

  };
}
