{ pkgs, lib, ... }:
let
  starshipper = import ./starshipper.nix { inherit lib; };
  divider = starshipper.divider "";
  segments = [
    (starshipper.beginning "")
    (starshipper.section {
      description = "core";
      background = "#9A348E";
      foreground = "#FFFFFF";
      shared = { };
      modules = [
        {
          name = "os";
          # style = "bg:#9A348E";
          disabled = true; # Disabled by default
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
          style_user = "bg:#9A348E";
          style_root = "bg:#9A348E";
          format = "[$user ]($style)";
          disabled = false;
        }
        {
          name = "hostname";
          ssh_symbol = " ";
        }
        {
          name = "memory_usage";
          symbol = "󰍛 ";
        }
      ];
    })
    divider
    (starshipper.section {
      description = "dir";
      # background = "#DA627D";
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
      # background = "#FCA17D";
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
      description = "context";
      # background = "#06969A";
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
          format = "[ $symbol$state( \($name\)) ]($style)";
          symbol = " ";
        }
      ];
    })
    divider
    (starshipper.section {
      description = "tool";
      # background = "#86BBD8";
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
  ];
  inherit (starshipper.mkStarship segments) format settings;

  flavour = "macchiato";
in
{
  format = "${format}\n$character";

  palette = "catppuccin_macchiato";
}
// (builtins.fromTOML (
  builtins.readFile (
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "starship";
      rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
      sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
    }
    + /palettes/${flavour}.toml
  )
))
// settings
