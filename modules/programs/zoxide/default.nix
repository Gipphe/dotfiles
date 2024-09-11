{
  lib,
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
    home.activation.set-zoxide-options = lib.hm.dag.entryAfter [ "onFilesChange" ] ''
      echo "Invoke-Expression (& { (zoxide init ${builtins.toString config.programs.zoxide.options} powershell | Out-String) })" > "${config.home.homeDirectory}/projects/dotfiles/windows/Config/zoxide.ps1"
    '';
  };
}
