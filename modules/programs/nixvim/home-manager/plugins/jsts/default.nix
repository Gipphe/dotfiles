{
  imports = [
    ./pnpm.nix
    ./prettier.nix
  ];
  programs.nixvim.plugins.lsp.servers = {
    eslint.enable = true;
    tailwindcss.enable = true;
    ts-ls.enable = true;
  };
}
