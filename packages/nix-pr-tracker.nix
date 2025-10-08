{
  writeFishApplication,
  coreutils,
  git,
  pr-tracker,
}:
writeFishApplication {
  name = "nix-pr-tracker";
  runtimeInputs = [
    coreutils
    git
    pr-tracker
  ];
  text = # fish
    ''
      argparse p/pr= r/repo= n/remote-name= -- $argv
      or exit 1

      set -l token (read)

      function info
        echo "$argv" > &2
      end

      function print-usage
        info "Usage: nix-pr-tracker -p|--pr <pr-number> -r|--repo <repo-path> -n|--remote-name <remote-name>"
        info "Args:"
        info "  -p|--pr           PR number to check."
        info "  -r|--repo         Path to nixpkgs repository to use to monitor."
        info "  -n|--remote-name  Name of the git remote to use for fetching from upstream nixpkgs."
        info ""
        info "This program expects a GitHub private access token to be passed through stdin."
      end

      if test -z "$_flag_pr"
        info "Missing --pr arg"
        print-usage
        exit 1
      end

      if test -z "$_flag_r"
        info "Missing --repo arg"
        print-usage
        exit 1
      end

      if test -z "$_flag_n"
        info "Missing --remote-name arg"
        print-usage
        exit 1
      end

      if test -z "$token"
        info "Missing token on stdin"
        print-usage
        exit 1
      end

      set -l repo_path "$_flag_r"
      set -l remote_name "$_flag_n"

      mkdir -p "$(dirname -- "$repo_path")"

      if ! test -d "$repo_path"
        info "Cloning nixpkgs repo..."
        git clone --bare git@github.com:nixos/nixpkgs.git "$repo_path"
      end
      pr-tracker --pr "$_flag_pr" --path "$repo_path" --remote "$remote_name" 
    '';
}
