{ util, ... }:
util.mkProfile {
  name = "keyring";
  shared.gipphe.programs.gnome-keyring.enable = true;
}
