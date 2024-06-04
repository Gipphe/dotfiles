{
  lib,
  flags,
  pkgs,
  ...
}:
lib.optionalAttrs (flags.wsl && flags.vscode) {
  # home.file.".vscode-server/server-env-setup".source = ./vscode-server-env-setup.sh;
  home.activation.copy-vscode-server-env-setup = ''
    dest="$HOME/.vscode-server/server-env-setup"
    run cp -f ${./vscode-server-env-setup.sh} "$dest" && chmod +x "$dest"
  '';
  home.packages = with pkgs; [ wget ];
}
