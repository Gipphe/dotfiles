{
  lib,
  config,
  util,
  ...
}:
util.mkModule {
  options.gipphe.programs.zoxide.enable = lib.mkEnableOption "zoxide";
  hm = lib.mkIf config.gipphe.programs.zoxide.enable {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
    home.activation.set-zoxide-options = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Invoke-Expression (& { (zoxide init ${builtins.toString config.programs.zoxide.options} powershell | Out-String) })" > "${config.home.homeDirectory}/projects/dotfiles/windows/Config/zoxide.ps1"
    '';
  };
}
