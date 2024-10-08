{ util, pkgs, ... }:
util.mkProgram {
  name = "wsl-cursor";
  hm.home = {
    file.".vscode-server/server-env-setup".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/sonowz/vscode-remote-wsl-nixos/refs/heads/master/server-env-setup";
      hash = "sha256-Kd/qp4gY9WnbX4bSewytmeuyqWFwiobP7G7nxMEW8ac=";
    };
    # Required for VSCode/Cursor WSL extension.
    packages = [ pkgs.wget ];
  };
}
