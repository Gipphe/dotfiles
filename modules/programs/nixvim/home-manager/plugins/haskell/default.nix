{ lib, config, ... }:
{
  imports = [
    ./haskell-tools.nix
    ./haskell-scope-highlighting.nix
  ];

  config = lib.mkIf config.gipphe.programs.nixvim.plugins.haskell.enable {
    programs.nixvim.plugins = {
      conform-nvim.settings.formatters_by_ft = {
        haskell = [ "fourmolu" ];
        cabal = [ "cabal_fmt" ];
      };
      lsp.servers.hls = {
        enable = true;
        installGhc = false;
      };
    };
  };
}
