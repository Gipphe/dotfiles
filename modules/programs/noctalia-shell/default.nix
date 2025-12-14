{
  lib,
  util,
  inputs,
  config,
  ...
}:
let
  ipc = "${lib.getExe' config.programs.noctalia-shell.package "noctalia-shell"} -p '${config.programs.noctalia-shell.package}/share/noctalia-shell' ipc call";
in
util.mkProgram {
  name = "noctalia-shell";
  hm = {
    imports = [ inputs.noctalia-shell.homeModules.default ];
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
      settings = lib.mkForce "${./settings.nix}";
    };
    home.file."Pictures/wallpapers/small-memory.png".source = config.stylix.image;
    gipphe.core.wm.binds = [
      {
        mod = "Mod";
        key = "space";
        action.spawn = "${ipc} launcher toggle";
      }
      {
        mod = "Mod";
        key = "c";
        action.spawn = "${ipc} launcher clipboard";
      }
    ];
  };
  system-nixos = {
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services = {
      auto-cpufreq.enable = lib.mkForce false;
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
