{
  lib,
  util,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.nix-pr-tracker;
  nix-pr-tracker = util.writeFishApplication {
    name = "nix-pr-tracker";
    runtimeInputs = [
      inputs.pr-tracker.packages.${pkgs.system}.default
      pkgs.coreutils
    ];
    runtimeEnv = {
      repo_path = cfg.repo-path;
      remote_name = cfg.remote-name;
    };
    text = # fish
      ''
        argparse p/pr= -- $argv
        or exit 1

        function info
          echo "$argv" > &2
        end

        if set -ql _flag_pr || test "$_flag_pr" = ""
          info "Usage: nix-pr-tracker -p|--pr <pr-number>"
          exit 1
        end

        mkdir -p "$(dirname -- "$repo_path")"

        if ! test -d "$repo_path"
          info "Cloning nixpkgs repo..."
          git clone --bare git@github.com:nixos/nixpkgs.git "$repo_path"
        end
        cat "${config.sops.secrets.pr-tracker-github-token.path}" |
          pr-tracker --pr "$_flag_pr" --path "$repo_path" --remote "$remote_name" 
      '';
  };
in
util.mkProgram {
  name = "nix-pr-tracker";
  options.gipphe.programs.nix-pr-tracker = {
    repo-path = lib.mkOption {
      description = "Path to clone nixpkgs into for monitoring.";
      type = lib.types.str;
      default = "${config.xdg.stateHome}/gipphe/nix-pr-tracker/nixpkgs";
    };
    remote-name = lib.mkOption {
      description = "Name of the remote to fetch from.";
      type = lib.types.str;
      default = "origin";
    };
  };
  hm = {
    home.packages = [
      nix-pr-tracker
    ];
    sops.secrets.pr-tracker-github-token = {
      format = "binary";
      sopsFile = ../../../secrets/pub-pr-tracker-github-token.txt;
    };
  };
}
