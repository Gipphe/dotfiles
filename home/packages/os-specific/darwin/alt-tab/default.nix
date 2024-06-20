{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  options.gipphe.programs.alt-tab.enable = lib.mkEnableOption "alt-tab";
  config = lib.mkIf config.gipphe.programs.alt-tab.enable {
    home.activation.import-alt-tab-config = ''
      run /usr/bin/defaults import com.lwouis.alt-tab-macos ${./alt-tab.xml}
    '';
    home.packages = with inputs.brew-nix.packages.${pkgs.system}; [ alt-tab ];
  };
}
