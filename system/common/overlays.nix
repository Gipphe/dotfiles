{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      nodePackages = prev.nodePackages // {
        inherit (inputs.nixpkgs-bashls-fix.legacyPackages.${prev.system}.nodePackages) bash-langauge-server;
      };
    })
  ];
}
