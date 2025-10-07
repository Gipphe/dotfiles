{
  treefmt,
  deadnix,
  entr,
  git,
  nh,
  nix-output-monitor,
  nix-tree,
  nixfmt,
  nvd,
  sops,
  statix,
  mkShell,
  callPackage,
}:
let
  extra = callPackage ./devShell.nix { };
in
mkShell {
  name = "dotfiles";
  commands = extra.shellCommands;
  env = extra.shellEnv;
  packages = [
    treefmt # treewide formatter
    deadnix # clean up unused nix code
    entr # run commands on file changes
    git # flake requires git
    nh # better nix CLI
    nix-output-monitor # pretty nix output
    nix-tree
    nixfmt # nix formatter
    nvd # Diff nix results
    sops
    statix # lints and suggestions
  ];
}
