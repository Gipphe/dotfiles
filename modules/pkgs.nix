{ inputs, den, ... }: {
  den.aspects.overlays.os.nixpkgs.overlays = [
    (_final: prev: {
      inherit (inputs.flaketilities.lib.${prev.stdenv.hostPlatform.system}) writeNushellApplication;
    })
  ];
  den.schema.host.includes = [ den.aspects.overlays ];
}
