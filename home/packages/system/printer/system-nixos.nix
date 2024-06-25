{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.services.printer.enable {
    # Enable CUPS to print documents.
    printing.enable = true;
  };
}
