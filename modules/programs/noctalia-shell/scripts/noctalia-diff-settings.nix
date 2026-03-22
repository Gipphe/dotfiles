{
  writeShellApplication,
  colordiff,
  json-diff,
  jq,
  nix,
  noctalia-shell,
}:
writeShellApplication {
  name = "noctalia-diff-settings";
  runtimeInputs = [
    colordiff
    json-diff
    jq
    nix
    noctalia-shell
  ];
  runtimeEnv.settings_file = ../settings.nix;
  text = /* bash */ ''
    json-diff \
      <(jq -S . <(nix eval --json --file "$settings_file")) \
      <(noctalia-shell ipc call state all | jq -S .settings) \
      | colordiff --nobanner
  '';
}
