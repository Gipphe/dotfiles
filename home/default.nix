{ utils, lib, ... }:
{
  # imports =
  #   utils.recurseFirstMatching "default.nix" ./.
  #   ++ lib.filesystem.listFilesRecursive ./profiles;
  imports = [
    # ./modules/system/systemd
    # ./modules/system/hardware-configuration
    ./modules/core
    ./modules/environment/desktop/plasma
    ./modules/environment/desktop/hyprland
    ./modules/environment/secrets
    ./modules/environment/theme/catppuccin
    ./modules/environment/wallpaper/small-memory-wallpaper
    ./modules/environment/rice

    ./modules/programs/_1password
    ./modules/programs/_1password-gui
    ./modules/programs/alt-tab
    ./modules/programs/appimage
    ./modules/programs/barrier
    ./modules/programs/bat
    ./modules/programs/bcn
    ./modules/programs/cava
    ./modules/programs/cool-retro-term
    ./modules/programs/curl
    ./modules/programs/cyberduck
    ./modules/programs/direnv
    ./modules/programs/discord
    ./modules/programs/entr
    ./modules/programs/eza
    ./modules/programs/fastgron
    ./modules/programs/fd
    ./modules/programs/filen
    ./modules/programs/fish
    ./modules/programs/fzf
    ./modules/programs/gh
    ./modules/programs/gimp
    ./modules/programs/git
    ./modules/programs/glab
    ./modules/programs/gnused
    ./modules/programs/gnutar
    ./modules/programs/google-cloud-sdk
    ./modules/programs/gpg
    ./modules/programs/homebrew
    ./modules/programs/idea
    ./modules/programs/imagemagick
    ./modules/programs/jq
    ./modules/programs/jujutsu
    ./modules/programs/karabiner-elements
    ./modules/programs/kitty
    ./modules/programs/less
    ./modules/programs/libgcc
    ./modules/programs/linearmouse
    ./modules/programs/logi-options-plus
    ./modules/programs/lutris
    ./modules/programs/mpc-cli
    ./modules/programs/neo4j-desktop
    ./modules/programs/neovim
    ./modules/programs/nh
    ./modules/programs/nix
    ./modules/programs/nix-index
    ./modules/programs/nixvim
    ./modules/programs/nnn
    ./modules/programs/notion
    ./modules/programs/obsidian
    ./modules/programs/openvpn-connect
    ./modules/programs/ripgrep
    ./modules/programs/run-as-service
    ./modules/programs/slack
    ./modules/programs/spotify-player
    ./modules/programs/ssh
    ./modules/programs/thefuck
    ./modules/programs/tmux
    ./modules/programs/vim
    ./modules/programs/vivaldi
    ./modules/programs/wezterm
    ./modules/programs/xclip
    ./modules/programs/xnviewmp
    ./modules/programs/zellij
    ./modules/programs/zoxide

    ./modules/system/audio
    ./modules/system/console
    ./modules/system/dbus
    ./modules/system/hardware-configuration
    ./modules/system/home-manager
    ./modules/system/journald
    ./modules/system/keyboard
    ./modules/system/localization
    ./modules/system/nix-ld
    ./modules/system/nvidia
    ./modules/system/printer
    ./modules/system/systemd
    ./modules/system/udisks2
    ./modules/system/user
    ./modules/system/wsl
    ./modules/system/zramswap

    # ./modules/system/audio
    # ./modules/system/console
    # ./modules/system/journald
    # ./modules/system/keyboard
    # ./modules/system/localization
    # ./modules/system/nix-ld
    # ./modules/system/systemd
    # ./modules/system/user
    # ./modules/system/wsl
    # ./modules/system/udisks2
    # ./modules/system/zramswap
    # ./modules/system/home-manager

    ./modules/virtualization/virtualbox-guest
    ./modules/virtualization/docker

    ./modules/boot/grub
    ./modules/boot/systemd-boot

    ./machines

    # ./profiles/core.nix
    # ./profiles/audio.nix
    # ./profiles/containers.nix
    # ./profiles/desktop.nix
    # ./profiles/fonts.nix
    # ./profiles/gaming.nix
    # ./profiles/nixos/audio.nix
    # ./profiles/nixos/system.nix
    # ./profiles/nixos/wsl.nix
    # ./profiles/rice.nix
    # ./profiles/secrets.nix
    # ./profiles/systemd.nix
    # ./profiles/vm-guest.nix
    # ./profiles/work.nix
    # ./profiles/nixos/wsl.nix
    # ./profiles/darwin.nix
    # ./profiles/logitech.nix
    # ./profiles/kvm.nix
  ] ++ lib.filesystem.listFilesRecursive ./profiles;
}
