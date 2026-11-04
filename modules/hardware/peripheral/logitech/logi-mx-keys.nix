{
  den.aspects.hardware.peripheral.logitech.logi-mx-keys = { grimblast }: {
    homeManager =
      { lib, ... }:
      {
        config = lib.mkIf grimblast.enable {
          gipphe.core.wm.bind = {
            # Logitech MX Keys screenshot hotkey sends SUPER_L+SHIFT_L+S
            "SUPER_L + SHIFT_L + S".action.spawn = "${grimblast.package} copy area";
            "SUPER_L + SHIFT_L + ALT_L + S".action.spawn = "${grimblast.package} copy screen";
          };
        };
      };
    nixos = {
      programs.solaar = {
        enable = true;
        userService.enable = true;
      };
    };
  };
}
