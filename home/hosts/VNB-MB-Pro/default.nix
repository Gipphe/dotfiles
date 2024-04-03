{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  config.nixpkgs.config.allowUnfree = true;
  config.fonts.fontconfig.enable = lib.mkIf (!isDarwin) true;
  config.home = {
    stateVersion = "23.11"; # Please read the comment before changing.
    username = "victor";
    homeDirectory = lib.mkForce "/Users/victor";
    sessionVariables.PAGER = "less -FXR";
    sessionVariables.FLAKE = "${config.home.homeDirectory}/projects/dotfiles";
  };
  config.programs.home-manager.enable = true;

  imports = [
    inputs.nix-index-db.hmModules.nix-index
    inputs.nixvim.homeManagerModules.nixvim
    ../../cli
    ../../services.nix
  ];
  # home.packages = with pkgs; [
  #   kubectx
  #   (google-cloud-sdk.withExtraComponents {
  #     components = [
  #       "gke-cloud-auth-plugin"
  #       "gcloud-crc32c"
  #     ];
  #   })
  #   jetbrains.idea-ultimate
  #   reattach-to-user-namespace
  #   alt-tab-macos
  #   cyberduck
  #   (import ../../home/packages/filen { inherit pkgs system; })
  # ];
  #
  # protrams.barrier.client = {
  #   enable = true;
  #   enableDragDrop = true;
  #   machine.name = "VNB-MB-Pro";
  # };
}
