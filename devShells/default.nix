{
  treefmt,
  deadnix,
  git,
  nh,
  nix-tree,
  nixfmt,
  sops,
  statix,
  mkShell,
  callPackage,
}:
let
  extra = callPackage ./devShell.nix { inherit treefmt; };
in
mkShell {
  name = "dotfiles";
  commands = extra.shellCommands;
  env = extra.shellEnv;
  packages = [
    treefmt # treewide formatter
    deadnix # clean up unused nix code
    git # flake requires git
    nh # better nix CLI
    nix-tree
    nixfmt # nix formatter
    sops
    statix # lints and suggestions
  ];
}
