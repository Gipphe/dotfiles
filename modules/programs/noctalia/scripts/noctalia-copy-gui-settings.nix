{
  nixfmt,
  yq-go,
  jq,
  nix,
  noctalia,
  writeShellApplication,
}:
writeShellApplication {
  name = "noctalia-copy-gui-settings";
  runtimeInputs = [
    noctalia
    nix
    jq
    yq-go
    nixfmt
  ];
  text = /* bash */ ''
    dest="$HOME/projects/dotfiles/modules/programs/noctalia/settings.nix"
    file="$(mktemp)"
    noctalia config export | yq -p toml -o json >"$file"
    nix eval --expr "builtins.fromJSON (builtins.readFile \"$file\")" --impure > "$dest"
    nixfmt "$dest"
  '';
}
