{ lib, ... }:
let
  starshipper = import ./starshipper.nix { inherit lib; };
  divider = starshipper.divider "";
in
[
  (starshipper.beginning "")
  (starshipper.section {
    description = "core";
    background = "#9A348E";
    foreground = "#FFFFFF";
    shared = { };
    modules = [
      {
        name = "os";
        disabled = false;
        symbols = {
          Alpaquita = " ";
          Alpine = " ";
          AlmaLinux = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = "󰈺 ";
          openSUSE = " ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Redox = "󰀘 ";
          Solus = "󰠳 ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
        };
      }
      {
        name = "username";
        show_always = true;
        format = "[$user ]($style)";
        disabled = true;
      }
      {
        name = "hostname";
        disabled = false;
        ssh_symbol = " ";
      }
      {
        name = "memory_usage";
        disabled = false;
        symbol = "󰍛 ";
      }
    ];
  })
  divider
  (starshipper.section {
    description = "dir";
    background = "#D54E6C";
    foreground = "#FFFFFF";
    shared = { };
    modules = [
      {
        name = "directory";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        read_only = " 󰌾";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      }
    ];
  })
  divider
  (starshipper.section {
    description = "VCS";
    background = "#FB7D4B";
    foreground = "#FFFFFF";
    shared = { };
    modules = [
      {
        name = "fossil_branch";
        symbol = " ";
        format = "[ $symbol $branch ]($style)";
      }
      {
        name = "hg_branch";
        symbol = " ";
        format = "[ $symbol $branch ]($style)";
      }
      {
        name = "git_branch";
        symbol = " ";
        format = "[ $symbol $branch ]($style)";
      }
      {
        name = "pijul_channel";
        symbol = " ";
      }
      {
        name = "git_status";
        format = "[$all_status$ahead_behind ]($style)";
      }
    ];
  })
  divider
  (starshipper.section {
    description = "tool";
    background = "#4C9AC5";
    foreground = "#FFFFFF";
    shared = {
      format = "[ $symbol ($version) ]($style)";
    };
    modules = [
      {
        name = "aws";
        symbol = "  ";
      }
      {
        name = "buf";
        symbol = " ";
      }
      {
        name = "c";
        symbol = " ";
      }
      {
        name = "conda";
        symbol = " ";
      }
      {
        name = "crystal";
        symbol = " ";
      }
      {
        name = "dart";
        symbol = " ";
      }
      {
        name = "elixir";
        symbol = " ";
      }
      {
        name = "elm";
        symbol = " ";
      }
      {
        name = "fennel";
        symbol = " ";
      }
      {
        name = "golang";
        symbol = " ";
      }
      { name = "gradle"; }
      {
        name = "haskell";
        symbol = " ";
      }
      {
        name = "haxe";
        symbol = " ";
      }
      {
        name = "java";
        symbol = " ";
      }
      {
        name = "julia";
        symbol = " ";
      }
      {
        name = "kotlin";
        symbol = " ";
      }
      {
        name = "lua";
        symbol = " ";
      }
      {
        name = "nim";
        symbol = "󰆥 ";
      }
      {
        name = "nodejs";
        symbol = " ";
      }
      {
        name = "ocaml";
        symbol = " ";
      }
      {
        name = "perl";
        symbol = " ";
      }
      {
        name = "php";
        symbol = " ";
      }
      {
        name = "python";
        symbol = " ";
      }
      {
        name = "rlang";
        symbol = "󰟔 ";
      }
      {
        name = "ruby";
        symbol = " ";
      }
      {
        name = "rust";
        symbol = " ";
      }
      {
        name = "scala";
        symbol = " ";
      }
      {
        name = "swift";
        symbol = " ";
      }
      {
        name = "zig";
        symbol = " ";
      }
      {
        name = "package";
        symbol = "󰏗 ";
      }
    ];
  })
  divider
  (starshipper.section {
    description = "context";
    background = "#057E81";
    foreground = "#FFFFFF";
    shared = { };
    modules = [
      {
        name = "docker_context";
        symbol = " ";
        format = "[ $symbol $context ]($style)";
      }
      {
        name = "guix_shell";
        symbol = " ";
      }
      {
        name = "meson";
        symbol = "󰔷 ";
      }
      {
        name = "nix_shell";
        format = "[ $symbol$state ]($style)";
        symbol = " ";
      }
    ];
  })
  divider
  (starshipper.section {
    description = "time";
    background = "#33658A";
    foreground = "#FFFFFF";
    shared = { };
    modules = [
      {
        name = "time";
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        format = "[ $time ]($style)";
      }
    ];
  })
  (starshipper.end " ")
]
