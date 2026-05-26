{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "keyboard";
  nixos = {
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "no";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "no";
  };
}
