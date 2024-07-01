{
  shellCommands = [
    # Build
    {
      help = "Rebuild the system using nh, darwin-rebuild or home-manager, whichever is applicable";
      name = "sw";
      command = # bash
        ''
          if command -v nixos-rebuild &>/dev/null; then
            nh os switch
          elif command -v darwin-rebuild &>/dev/null; then
            darwin-rebuild build --flake $(pwd)
            echo
            nvd diff /run/current-system result
            echo
            darwin-rebuild switch --flake $(pwd)
            rm -f result
          elif command -v home-manager &>/dev/null; then
            nh home switch
          fi
        '';
      category = "build";
    }
    {
      help = "Rebuild the system using nh os switch --ask";
      name = "swa";
      command = # bash
        ''
          if command -v nixos-rebuild &> /dev/null; then
            nh os switch --ask
          elif command -v darwin-rebuild &>/dev/null; then
            darwin-rebuild build --flake $(pwd)

            echo
            nvd diff /run/current-system result
            echo

            echo "Apply the config?"
            read -p "[y/N]" -n 1 REPLY
            echo

            case "$REPLY" in
              y|Y) darwin-rebuild switch --flake $(pwd) ;;
            esac
            rm -f result
          else
            echo "This is not a NixOS system" >&2
            exit 1
          fi
        '';
      category = "build";
    }
    {
      help = "Rebuild the system using nh os boot";
      name = "boot";
      command = # bash
        ''
          if command -v nixos-rebuild &> /dev/null; then
            nh os boot
          else
            echo "This is not a NixOS system" >&2
            exit 1
          fi
        '';
      category = "build";
    }

    # Formatting
    {
      help = "Format the source tree with treefmt";
      name = "fmt";
      command = # bash
        "treefmt";
      category = "formatter";
    }

    # Utils
    {
      help = "Update flake inputs and commit changes";
      name = "update";
      command = # bash
        ''nix flake update && git commit flake.lock -m "chore: update flake inputs"'';
      category = "utils";
    }

    # Nix utils
    {
      help = "Track distribution of PR";
      name = "nix:pr";
      command = # bash
        ''
          if test -z "$1"; then
            echo "Usage: nix:pr <pr number>"
            exit 1
          fi
          prg=$(command -v open || command -v xdg-open)
          eval "$prg 'https://nixpk.gs/pr-tracker.html?pr=$1'"
        '';
      category = "nix utils";
    }
    {
      help = "View store path sizes";
      name = "nix:du";
      command = # bash
        "nix path-info -rS /run/current-system | sort -nk2";
      category = "nix utils";
    }

    # Linting
    {
      help = "Check .nix files with statix";
      name = "lint:statix";
      command = # bash
        "statix check";
      category = "lint";
    }
    {
      help = "Check .nix files with statix, watching";
      name = "lint:statix:watch";
      command = # bash
        "find . -type f | entr static check";
      category = "lint";
    }
    {
      help = "Check .nix files with deadnix";
      name = "lint:deadnix";
      command = # bash
        "deadnix --exclude ./system/*/hardware-configuration/*.nix";
      category = "lint";
    }
    {
      help = "Check .nix files with deadnix, watching";
      name = "lint:deadnix:watch";
      command = # bash
        "find . -type f | entr deadnix --exclude ./system/*/hardware-configuration/*.nix";
      category = "lint";
    }
  ];

  shellEnv = [
    {
      # make direnv shut up
      name = "DIRENV_LOG_FORMAT";
      value = "";
    }
  ];
}
