{ pkgs, lib, ... }:
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
        format = "[$symbol$ram( | $swap) ]($style)";
      }
      {
        name = "shlvl";
        threshold = 5;
        format = "[$shlvl ]($style)";
        disabled = false;
      }
    ];
  })
  (starshipper.section (
    let
      foreground = "blue";
    in
    {
      inherit foreground;
      description = "dir";
      shared = { };
      modules = [
        {
          name = "directory";
          format = "[$path ]($style)[$read_only]($read_only_style)";
          fish_style_pwd_dir_length = 1;
          # truncation_length = 3;
          # truncation_symbol = "…/";
          read_only = " 󰌾";
          truncate_to_repo = false;
          before_repo_root_style = "dimmed ${foreground}";
          repo_root_style = "underline ${foreground}";
          read_only_style = "red";
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
          };
        }
      ];
    }
  ))
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
        disabled = true;
      }
      {
        name = "git_branch";
        custom = true;
        when = "! jj --ignore-working-copy root";
        command = "starship module git_branch";
        description = "Only show git_branch if we're not in a jj repo";
        style = "";
      }
      {
        name = "pijul_channel";
        symbol = " ";
        format = "[$symbol$channel ]($style)";
      }
      {
        name = "git_status";
        format = "[$all_status$ahead_behind ]($style)";
        disabled = true;
      }
      {
        name = "git_status";
        custom = true;
        when = "! jj --ignore-working-copy root";
        command = "starship module git_status";
        style = "";
        description = "Only show git_status if we're not in a jj repo";
      }
    ];
  })
  (starshipper.section {
    description = "jj";
    foreground = "";
    shared = { };
    modules = [
      (
        let
          jj = lib.getExe pkgs.jujutsu;
        in
        {
          name = "jj";
          custom = true;
          description = "The current jj status";
          when = "${jj} --ignore-working-copy root";
          symbol = " ";
          command = ''
            ${jj} log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
              separate(" ",
                change_id.shortest(4),
                truncate_end(15, bookmarks),
                "|",
                concat(
                  if(conflict, "💥"),
                  if(divergent, "🚧"),
                  if(hidden, "👻"),
                  if(immutable, "🔒"),
                ),
                raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
                raw_escape_sequence("\x1b[1;32m") ++ coalesce(
                  truncate_end(29, description.first_line(), "…"),
                  "(no description set)",
                ) ++ raw_escape_sequence("\x1b[0m"),
              )
            '
          '';
        }
      )
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
      {
        name = "gradle";
        symbol = " ";
      }
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
        disabled = true;
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
