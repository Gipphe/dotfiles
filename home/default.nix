{ utils, ... }:
{
  # imports = utils.recurseFirstMatching "default.nix" ./.;
  imports = [
    ./packages/core
    # ./packages/system/systemd
    # ./packages/system/hardware-configuration
    ./packages/tools/package-management/nix
    ./machines
  ];
}
