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
  };
}
