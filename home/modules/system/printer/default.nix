{ util, ... }:
util.mkToggledModule [ "services" ] {
  name = "printer";
  # Enable CUPS to print documents.
  system-nixos.services.printing.enable = true;
}
