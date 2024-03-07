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
    # mosh
    ranger
    # rclone
    ripgrep

    # Libraries
    imagemagick

    # Utilities
    curl
    # pv
    # watch
    # tree
    # hurl
    entr
    fastgron
    fd
    _1password
    docker

    # Cryptography
    age
    # magic-wormhole
    # openssh
    openssl
    # pwgen-secure
    # rage

    # Programming tools
    glab
    python3Full

    # Language servers
    shellcheck
    vale

    # System and network tools
    # bandwhich
    # httpie
    # netcat

    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
