{
  lib,
  util,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.nix-pr-tracker;
  repo_path =
    if cfg.repo-path != null then
      cfg.repo-path
    else
      "${config.xdg.stateHome}/gipphe/nix-pr-tracker/nixpkgs";
  pr-tracker =
    (builtins.getFlake "github:Gipphe/pr-tracker/7889bb3287ec35f570ec7da67a4c6bf91a610cb0")
    .packages.${pkgs.system}.default;
  nix-pr-tracker = util.writeFishApplication {
    name = "nix-pr-tracker";
    runtimeInputs = [
      pr-tracker
      pkgs.git
      pkgs.coreutils
    ];
    text = # fish
      ''
        argparse h/help p/pr= -- $argv
        or exit 1

        function info
          echo "$argv" >&2
        end

        function print-usage
          info "Usage: nix-pr-tracker -p|--pr <pr-number>"
          info "Args:"
          info "  -p|--pr <pr-number>  PR number to check."
          info "  -h|--help            Print this help text."
        end

        if set -ql _flag_h
          print-usage
          exit 0
        end

        if test -z "$_flag_pr"
          info "Missing --pr arg"
          print-usage
          exit 1
        end

        if test -z "$repo_path"
          info "Repo path is empty: $repo_path"
          exit 1
        end

        set -l repo_path "${repo_path}"
        set -l remote_name "${cfg.remote-name}"

        mkdir -p "$(dirname -- "$repo_path")"

        if ! test -d "$repo_path"
          info "Cloning nixpkgs repo..."
          git clone --bare git@github.com:nixos/nixpkgs.git "$repo_path"
          or exit 1
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
      type = with lib.types; nullOr str;
      default = null;
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
