{ inputs, ... }:
{
  imports = [./base.nix];
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.neovim-overlay.overlay ];
  };
}
