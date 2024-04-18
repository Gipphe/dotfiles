{
  shellCommands = [
    # Build
    {
      help = "Rebuild the system using nixos-rebuild, darwin-rebuild or home-manager, whichever is applicable";
      name = "sw";
      command = ''
        if command -v nixos-rebuild &>/dev/null; then
          nh os switch
        elif command -v darwin-rebuild &>/dev/null; then
          darwin-rebuild switch --flake $(pwd)
        elif command -v home-manager &>/dev/null; then
          nh home switch
        fi
      '';
      category = "build";
    }
    {
      help = "Rebuild the system using nh os boot";
      name = "boot";
      command = ''
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
      command = "treefmt";
      category = "formatter";
    }

    # Utils
    {
      help = "Update flake inputs and commit changes";
      name = "update";
      command = ''nix flake update && git commit flake.lock -n "flake: bump inputs"'';
      category = "utils";
    }

    # Linting
    {
      help = "Check .nix files with statix";
      name = "lint-statix";
      command = "statix check";
      category = "lint";
    }
    {
      help = "Check .nix files with statix, watching";
      name = "lint-statix-watch";
      command = "find . -type f | entr static check";
      category = "lint";
    }
    {
      help = "Check .nix files with deadnix";
      name = "lint-deadnix";
      command = "deadnix --exclude ./hosts/*/hardware-configuration.nix";
      category = "lint";
    }
    {
      help = "Check .nix files with deadnix, watching";
      name = "lint-deadnix-watch";
      command = "find . -type f | entr deadnix --exclude ./hosts/*/hardware-configuration.nix";
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
