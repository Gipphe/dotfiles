{
  config,
  util,
  ...
}:
util.mkProgram {
  name = "zoxide";
  hm = {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
    gipphe.windows.home.file.".config/zoxide.ps1".text = # powershell
      ''
        echo "Invoke-Expression (& { (zoxide init ${builtins.toString config.programs.zoxide.options} powershell | Out-String) })" > "${config.home.homeDirectory}/projects/dotfiles/windows/Config/zoxide.ps1"
      '';
  };
}
