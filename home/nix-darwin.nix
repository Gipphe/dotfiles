{ utils, ... }:
{
  # imports = utils.importSubdirs "system-darwin.nix" ./. ++ utils.importSubdirs "system-all.nix" ./.;
  imports = [
    ./modules/applications/misc/1password-gui/system-darwin.nix
    ./modules/applications/virtualization/docker/system-darwin.nix
    ./modules/os-specific/darwin/logi-options-plus/system-darwin.nix
    ./modules/os-specific/darwin/openvpn-connect/system-darwin.nix
    ./modules/tools/package-management/homebrew/system-darwin.nix
  ];
}
