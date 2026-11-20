{ inputs, ... }:
{
  den.aspects.gaming.kernel = {
    nixos = { pkgs, ... }: {
      boot.kernelPackages =
        inputs.nix-cachyos-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linux-cachyos-lts;
      nix.settings.trusted-substituters = [ "https://cache.lantian.pub/lantian" ];
      nix.settings.trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];
    };
  };
}
