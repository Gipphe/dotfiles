{
  den.aspects.system.printer.nixos = { pkgs, ... }: {
    services = {
      printing = {
        enable = true;
        cups-pdf.enable = true;
        browsing = true;
        browsed.enable = true;
        drivers = [
          pkgs.gutenprint
          pkgs.cups-filters
          pkgs.cups-browsed
        ];
      };
      # Allows auto-discovering printers on the network
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
