{ self, ... }:
{
  den.aspects.programs.headset-battery-indicator = {
    homeManager =
      { pkgs, lib, ... }:
      let
        pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.headset-battery-indicator;
      in
      {
        home.packages = [ pkg ];
        systemd.user.services.headset-battery-indicator = {
          Unit = {
            Description = "Headset battery indicator";
            Requires = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            ExecStart = lib.getExe pkg;
            Restart = "on-failure";
            RestartSteps = 3;
            RestartMaxDelaySec = 6;
          };
        };
      };
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.headsetcontrol ];
    };
  };
}
