{
  flags,
  pkgs,
  util,
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (builtins) listToAttrs map;
  binds = pkgs.callPackage ./binds.nix { };
  coreBinds = listToAttrs (map binds.toNiriBind config.gipphe.core.wm.binds);
in
util.mkProgram {
  name = "niri";
  hm = {
    imports =
      lib.optional (!flags.isNixOnDroid) {
        stylix.targets.niri.enable = lib.mkDefault false;
      }
      ++ lib.optional flags.isNixOnDroid inputs.niri.homeModules.config
      ++ lib.optional (!flags.isNixOnDroid && !flags.isNixos) inputs.niri.homeModules.stylix
      ++ lib.optional (!flags.isNixOnDroid && config.gipphe.programs.niri.enable) {
        stylix.targets.niri.enable = true;
      };
    programs.niri = {
      settings = {
        binds = coreBinds;
        keyboard = {
          numlock = true;
          xkb = {
            layout = "no";
          };
        };
        output = {
          "Dell Inc. DELL U2724D G11T4Z3" = "center";
          "Dell Inc. DELL U2724D G27V4Z3" = "right";
          "Dell Inc. DELL U2724D G15V4Z3" = "left";
        };
        xwayland-sattellite = {
          path = "${pkgs.xwayland-sattellite-unstable}";
        };
      };
    };
  };
  system-nixos = {
    imports = [ inputs.niri.nixosModules.niri ];
    programs.niri.enable = true;
  };
}
