{
  nixfmt,
  nix,
  noctalia,
  writeNushellApplication,
}:
writeNushellApplication {
  name = "noctalia-copy-gui-settings";
  runtimeInputs = [
    noctalia
    nix
    nixfmt
  ];
  text = /* nu */ ''
    let dest = $"($env.HOME)/projects/dotfiles/modules/programs/noctalia/_settings.nix"
    let file = mktemp
    noctalia config export | from toml | to json | save -f $file
    nix eval --expr $"builtins.fromJSON \(builtins.readFile \"($file)\")" --impure | save -f $dest
    nixfmt $dest
  '';
}
