{
  imports = [
    ./haskell-tools.nix
    ./haskell-scope-highlighting.nix
  ];

  programs.nixvim.plugins = {
    conform-nvim.formattersByFt.haskell = [ "fourmolu" ];
    lsp.servers.hls.enable = true;
  };
}
