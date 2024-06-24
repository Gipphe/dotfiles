{
  lib,
  flags,
  config,
  inputs,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.gimp.enable (
    lib.mkMerge [
      # Temporarily force use of the nixpkgs version of gimp on Macos
      (lib.mkIf (true || flags.system.isNixos) { home.packages = with pkgs; [ gimp-with-plugins ]; })
      (lib.mkIf (false && flags.system.isNixDarwin) {
        home.packages = [ inputs.brew-nix.packages.${pkgs.system}.gimp ];
      })
    ]
  );
}
