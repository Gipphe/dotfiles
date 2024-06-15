{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      nodePackages = prev.nodePackages // {
        inherit (inputs.nixpkgs-master.legacyPackages.${prev.system}.nodePackages) bash-language-server;
      };
    })
  ];
}
