{
  den.aspects.system.journald.nixos = { options, ... }: {
    # `services.journald.settings` only exists in newer nixpkgs. Hosts built
    # with an older one (e.g. sodium, via nixos-raspberrypi) use `extraConfig`.
    # A plain `if` is needed here: `mkIf` can't hide a definition for an
    # option that doesn't exist.
    config =
      if options.services.journald ? settings then
        {
          services.journald.settings.Journal = {
            SystemMaxUse = "2000M";
            RuntimeMaxUse = "500M";
          };
        }
      else
        {
          services.journald.extraConfig = ''
            SystemMaxUse=2000M
            RuntimeMaxUse=500M
          '';
        };
  };
}
