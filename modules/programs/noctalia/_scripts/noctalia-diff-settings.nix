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
    json-diff \
      <(nix eval --json /home/gipphe/projects/dotfiles#nixosConfigurations.titanium.config.home-manager.users.gipphe.programs.noctalia.settings | jq -S .) \
      <(noctalia config export | yq -p toml -o json | jq -S .) \
      | colordiff --nobanner
  '';
}
