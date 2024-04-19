{ lib, ... }:
let
  starshipper = import ./starshipper.nix { inherit lib; };
in
[
  (starshipper.section {
    description = "core";
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
      {
        name = "shlvl";
        threshold = 5;
        format = "[$shlvl ]($style)";
        disabled = false;
      }
    ];
  })
  (starshipper.section {
    description = "dir";
    foreground = "blue";
    shared = { };
    modules = [
      {
        name = "directory";
        format = "[$path ]($style)";
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
  (starshipper.section {
    description = "VCS";
    foreground = "green";
    shared = {
      format = "[$symbol$branch ]($style)";
    };
    modules = [
      {
        name = "fossil_branch";
        symbol = " ";
      }
      {
        name = "hg_branch";
        symbol = " ";
      }
      {
        name = "git_branch";
        symbol = " ";
      }
      {
        name = "pijul_channel";
        symbol = " ";
        format = "[$symbol$channel ]($style)";
      }
      {
        name = "git_status";
        format = "[$all_status$ahead_behind ]($style)";
      }
    ];
  })
  (starshipper.divider " ")
  (starshipper.section {
    description = "tool";
    foreground = "peach";
    shared = {
      format = "[$symbol($version) ]($style)";
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
  (starshipper.section {
    description = "separator line";
    foreground = "surface1";
    shared = { };
    modules = [
      {
        name = "fill";
        symbol = "-";
      }
    ];
  })
  (starshipper.section {
    description = "status";
    modules = [
      {
        name = "status";
        format = "[$symbol$status ]($style)";
        disabled = false;
      }
    ];
  })
  (starshipper.section {
    description = "context";
    foreground = "mauve";
    shared = { };
    modules = [
      {
        name = "direnv";
        symbol = " ";
        format = "[$symbol$loaded/$allowed ]($style)";
        allowed_msg = "";
        not_allowed_msg = "";
        denied_msg = "";
        loaded_msg = "";
        unloaded_msg = "";
        disabled = false;
      }
      {
        name = "docker_context";
        symbol = " ";
        format = "[$symbol$context ]($style)";
      }
      {
        name = "guix_shell";
        symbol = " ";
        format = "[$symbol]($style)";
      }
      {
        name = "meson";
        symbol = "󰔷 ";
        format = "[$symbol$project ]($style)";
      }
      {
        name = "nix_shell";
        format = "[$symbol$state ]($style)";
        symbol = " ";
      }
    ];
  })
  (starshipper.section {
    description = "time";
    foreground = "overlay1";
    shared = { };
    modules = [
      {
        name = "time";
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        format = "[$time ]($style)";
      }
    ];
  })
]
