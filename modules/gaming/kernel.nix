{
  util,
  inputs,
  pkgs,
  ...
}:
let
  mod = util.mkGaming {
    name = "kernel";
    nixos = {
      boot.kernelPackages =
        inputs.nix-cachyos-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linux-cachyos-lts;
    };
  };
in
util.mkModule {
  shared.imports = [ mod ];
  nixos = {
    # TODO: Re-enable once cache is back online.
    # See https://github.com/xddxdd/nix-cachyos-kernel/issues/110
    # nix.settings.trusted-substituters = [ "https://attic.xuyh0120.win/lantian" ];
    # nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };
}
