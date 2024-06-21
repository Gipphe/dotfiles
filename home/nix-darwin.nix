{ utils, ... }:
{
  # imports = utils.importSubdirs "nix-darwin.nix" ./.;
  imports = [
    ./packages/applications/misc/1password-gui/nix-darwin.nix
    ./packages/applications/virtualization/docker/nix-darwin.nix
    ./packages/os-specific/darwin/logi-options-plus/nix-darwin.nix
    ./packages/os-specific/darwin/openvpn-connect/nix-darwin.nix
    ./packages/tools/package-management/homebrew/nix-darwin.nix
  ];
}
