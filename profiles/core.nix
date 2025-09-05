{ util, ... }:
util.mkProfile {
  name = "core";
  shared.gipphe = {
    programs = {
      nix.enable = true;
      gnome-keyring.enable = true;
    };
    system.user.enable = true;
  };
}
