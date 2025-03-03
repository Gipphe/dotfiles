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
    gipphe.windows.profiles.titanium.home.file.".config/zoxide.ps1".text = # powershell
      ''
        Invoke-Expression (& { (zoxide init ${builtins.toString config.programs.zoxide.options} powershell | Out-String) })
      '';
  };
}
