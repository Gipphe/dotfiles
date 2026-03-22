{
  jq,
  nix,
  noctalia-shell,
  writeShellApplication,
}:
writeShellApplication {
  name = "noctalia-copy-gui-settings";
  runtimeInputs = [
    noctalia-shell
    nix
    jq
  ];
  text = /* bash */ ''
    dest="$HOME/projects/dotfiles/modules/programs/noctalia-shell/settings.nix"
    file="$(mktemp)"
    noctalia-shell ipc call state all | jq .settings > "$file"
    nix eval --expr "builtins.fromJSON (builtins.readFile \"$file\")" --impure > "$dest"
    nixfmt "$dest"
  '';
}
