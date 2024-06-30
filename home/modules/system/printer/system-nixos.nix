{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.services.printer.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
