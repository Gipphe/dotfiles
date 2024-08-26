{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "nix-ld";
  # Compatibility layer for dynamically linked binaries that expect FHS
  system-nixos.programs.nix-ld.enable = true;
}
