{
  writeNushellApplication,
  nix,
  fastgron,
  noctalia,
  colordiff,
}:
writeNushellApplication {
  name = "noctalia-diff-settings";
  runtimeInputs = [
    nix
    noctalia
    colordiff
    fastgron
  ];
  text = /* nu */ ''
    let old = mktemp
    let new = mktemp
    nix eval --json /home/gipphe/projects/dotfiles#nixosConfigurations.titanium.config.home-manager.users.gipphe.programs.noctalia.settings | fastgron - | save -f $old
    noctalia config export 
    | from toml 
    | to json 
    | fastgron -
    | save -f $new

    colordiff --nobanner $old $new
  '';
}
