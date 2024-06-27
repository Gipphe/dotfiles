{ inputs, ... }:
{
  imports = [ inputs.mac-app-util.darwinModules.default ];

  programs.zsh.enable = true;
}
