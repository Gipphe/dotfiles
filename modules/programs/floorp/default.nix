{
  util,
  lib,
  pkgs,
  flags,
  ...
}:
util.mkModule {
  options.gipphe.programs.floorp = {
    enable = lib.mkEnableOption "floorp";
    default = lib.mkEnableOption "Floorp as default browser" // {
      default = true;
    };
  };
  shared.imports = [
    ./default-opts.nix
    ./extensions.nix
    ./policies.nix
    ./profile
  ];
  hm = {
    config = lib.mkMerge [
      {
        programs.floorp = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && !flags.isNixOnDroid) {
          enable = true;
          nativeMessagingHosts = [ pkgs.tridactyl-native ];
        };
      }
      (lib.optionalAttrs (!flags.isNixOnDroid && flags.stylix) {
        stylix.targets.floorp.profileNames = [ "default" ];
      })
    ];
  };
}
