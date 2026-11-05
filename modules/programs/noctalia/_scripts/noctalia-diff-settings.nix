{
  writeNushellApplication,
  nix,
  fastgron,
  noctalia,
  diffutils,
}:
writeNushellApplication {
  name = "noctalia-diff-settings";
  runtimeInputs = [
    nix
    noctalia
    fastgron
    diffutils
  ];
  text = /* nu */ ''
    let old = mktemp
    let new = mktemp
    nix eval --json /home/gipphe/projects/dotfiles#nixosConfigurations.titanium.config.home-manager.users.gipphe.programs.noctalia.settings
      | fastgron -
      | save -f $old
    noctalia config export
      | from toml
      | to json
      | fastgron -
      | save -f $new

    diff --color $old $new
  '';
}
