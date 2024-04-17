{
  shellCommands = [
    # Build
    {
      help = "Rebuild the system using nh os switch";
      name = "sw";
      command = "nh os switch";
      category = "build";
    }
    {
      help = "Rebuild the system using nh os boot";
      name = "boot";
      command = "nh os boot";
      category = "build";
    }
    {
      help = "Rebuild nix-darwin using darwin-rebuild switch";
      name = "dw";
      command = "darwin-rebuild switch --flake $(pwd)";
      category = "build";
    }
    {
      help = "Rebuild the home environment using nh home switch";
      name = "hms";
      command = "nh home switch $(pwd)";
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
