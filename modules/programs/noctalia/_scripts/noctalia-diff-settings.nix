{
  writeNushellApplication,
  nix,
  noctalia,
  json-diff,
}:
writeNushellApplication {
  name = "noctalia-diff-settings";
  runtimeInputs = [
    nix
    noctalia
    json-diff
  ];
  text = /* nu */ ''
    let old = mktemp
    let new = mktemp

    nix eval --json '/home/gipphe/projects/dotfiles#nixosConfigurations.titanium.config.home-manager.users.gipphe.programs.noctalia.settings'
        | save -f $old
    noctalia config export
        | from toml
        | to json
        | save -f $new

    json-diff --color $old $new
  '';
}
