{
  callPackage,
  mkShell,

  deadnix,
  nix-tree,
  nixfmt,
  sops,
  statix,
}:
let
  extra = callPackage ./devShell.nix { };
in
mkShell {
  name = "dotfiles";
  commands = extra.shellCommands;
  env = extra.shellEnv;
  packages = [
    deadnix # clean up unused nix code
    nix-tree
    nixfmt # nix formatter
    sops
    statix # lints and suggestions
  ];
}
