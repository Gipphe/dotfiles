{
  writeShellApplication,
  colordiff,
  json-diff,
  jq,
  yq-go,
  nix,
  noctalia,
}:
writeShellApplication {
  name = "noctalia-diff-settings";
  runtimeInputs = [
    colordiff
    json-diff
    jq
    nix
    yq-go
    noctalia
  ];
  text = /* bash */ ''
    settings_file="$HOME/projects/dotfiles/modules/programs/noctalia/settings.nix"
    json-diff \
      <(nix eval --json --file "$settings_file" | jq -S .) \
      <(noctalia config export | yq -p toml -o json | jq -S .) \
      | colordiff --nobanner
  '';
}
