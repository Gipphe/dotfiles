{ pkgs, ... }: {
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Adds the 'hello' command to your environment. It prints a friendly
    # "Hello, world!" when run.
    # pkgs.hello

    # You can also create simple shell scripts directly inside your
    # configuration. For example, this adds a command 'my-hello' to your
    # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Essentials
    eza
    # mosh
    ranger
    rclone
    ripgrep

    # Utilities
    curl
    # pv
    # watch
    tree
    # hurl

    # Cryptography
    age
    # magic-wormhole
    openssh
    openssl
    # pwgen-secure
    # rage

    # Programming tools
    lazygit
    jujutsu
    glab
    gh-dash

    # Language servers
    shellcheck
    vale

    # System and network tools
    bandwhich
    htop
    httpie
    netcat

    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
