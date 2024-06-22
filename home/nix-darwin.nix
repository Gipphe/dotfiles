{ utils, ... }:
{
  # imports = utils.importSubdirs "system-darwin.nix" ./. ++ utils.importSubdirs "system-all.nix" ./.;
  imports = [
    ./packages/applications/misc/1password-gui/system-darwin.nix
    ./packages/applications/virtualization/docker/system-darwin.nix
    ./packages/os-specific/darwin/logi-options-plus/system-darwin.nix
    ./packages/os-specific/darwin/openvpn-connect/system-darwin.nix
    ./packages/tools/package-management/homebrew/system-darwin.nix
  ];
}
