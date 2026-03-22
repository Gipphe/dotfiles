{
  nix,
  writeShellApplication,
}:
writeShellApplication {
  name = "noctalia-copy-gui-settings";
  runtimeInputs = [ nix ];
  text = /* bash */ ''
    nix eval --expr 'builtins.fromJSON (builtins.readFile "$XDG_CONFIG_HOME/noctalia/gui-settings.json")' --impure > "$HOME/projects/dotfiles/modules/programs/noctalia-shell/settings.nix"
    nixfmt "$dest"
  '';
}
