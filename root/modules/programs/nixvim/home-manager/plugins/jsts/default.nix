{ inputs, pkgs, ... }:
{
  imports = [
    ./pnpm.nix
    ./prettier.nix
  ];
  programs.nixvim.plugins.lsp.servers = {
    eslint.enable = true;
    # Awaiting this PR to hit nixos-unstable: https://github.com/NixOS/nixpkgs/pull/335559
    eslint.package = inputs.nixpkgs-master.legacyPackages.${pkgs.system}.vscode-langservers-extracted;
    tailwindcss.enable = true;
    tsserver.enable = true;
  };
}
