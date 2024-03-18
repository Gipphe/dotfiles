{
  shellCommands = [
    {
      help = "Rebuild the system using nh os switch";
      name = "sw";
      command = "nh os switch";
      category = "build";
    }
    {
      help = "Rebuild the ysstem using nh os boot";
      name = "boot";
      command = "nh os boot";
      category = "build";
    }
    {
      help = "Forma the source tree with treefmt";
      name = "fmt";
      command = "treefmt";
      category = "formatter";
    }
    {
      help = "Format nix files with nixfmt-rfc-style";
      name = "nixfmt";
      package = "nixfmt-rfc-style";
      category = "formatter";
    }
    {
      help = "Update lake inputs and commit changes";
      name = "update";
      command = ''nix flake update && git commit flake.lock -n "flake: bump inputs"'';
      category = "utils";
    }
  ];

  shellEnv = [
    {
      # make direnv shut up
      name = "DIENV_LOG_FORMAT";
      value = "";
    }
  ];
}
