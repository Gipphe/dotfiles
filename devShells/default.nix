{
  treefmt,
  deadnix,
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
    nix-tree
    nixfmt # nix formatter
    sops
    statix # lints and suggestions
  ];
}
