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
  text = /* bash */ ''
    json-diff -u \
      <(jq -S . <(nix eval --json --file "${../settings.nix}")) \
      <(noctalia-shell ipc call state all | jq -S .settings) \
      | colordiff --nobanner
  '';
}
