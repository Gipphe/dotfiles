{
  lib,
  config,
  inputs,
  system,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.linearmouse.enable {
    xdg.configFile = {
      "linearmouse/linearmouse.json".text = builtins.toJSON {
        schemes = [
          {
            "if".device.category = "mouse";
            scrolling = {
              speed.vertical = 0;
              distance.vertical = "98.6px";
              acceleration.vertical = 1;
            };
            pointer.disableAcceleration = true;
          }
          {
            "if".device.category = "trackpad";
            scrolling.reverse = {
              vertical = false;
              horizontal = true;
            };
          }
          {
            "if".device = {
              productName = "Apple Internal Keyboard / Trackpad";
              category = "trackpad";
              vendorID = "0x0";
              productID = "0x0";
            };
            scrolling = {
              reverse.vertical = true;
              acceleration.vertical = 1;
            };
          }
        ];
        "$schema" = "https://schema.linearmouse.app/0.9.5";
      };
    };
    home.packages = [ inputs.brew-nix.packages.${system}.linearmouse ];
  };
}
