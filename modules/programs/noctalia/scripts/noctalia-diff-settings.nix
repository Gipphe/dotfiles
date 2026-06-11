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
  runtimeEnv.settings_file = builtins.path {
    path = ../settings.nix;
    name = "noctalia-settings.nix";
  };
  text = /* bash */ ''
    json-diff \
      <(nix eval --json --file "$settings_file" | jq -S .) \
      <(noctalia config export | yq -p toml -o json | jq -S .) \
      | colordiff --nobanner
  '';
}
