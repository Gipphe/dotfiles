{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.system.keyboard.enable {
    services = {
      # Configure keymap in X11
      xserver.xkb = {
        layout = "no";
        variant = "";
      };

    };
    console = lib.mkIf config.gipphe.system.console.enable {
      # Configure console keymap
      keyMap = "no";
    };
  };
}
