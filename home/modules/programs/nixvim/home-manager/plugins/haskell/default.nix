{ lib, config, ... }:
{
  imports = [
    ./haskell-tools.nix
    ./haskell-scope-highlighting.nix
  ];

  config = lib.mkIf config.gipphe.programs.nixvim.plugins.haskell.enable {
    programs.nixvim.plugins = {
      conform-nvim.formattersByFt.haskell = [ "fourmolu" ];
      lsp.servers.hls.enable = true;
    };

    # Required to prevent building GHC multiple times with haskell.nix
    nix.settings = {
      trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
      substituters = [ "https://cache.iog.io" ];
    };
  };
}
