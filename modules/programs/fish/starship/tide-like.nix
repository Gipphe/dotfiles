{ lib, jujutsu }:
let
  jj = lib.getExe jujutsu;

  machine_format = "$os$username$hostname$memory_usage";
  machine = {
    hostname = {
      disabled = false;
      ssh_symbol = " ";
      style = "fg:#FFFFFF";
    };

    memory_usage = {
      disabled = false;
      format = "[$symbol$ram( | $swap) ]($style)";
      style = "fg:#FFFFFF";
      symbol = "󰍛 ";
    };

    os = {
      disabled = false;
      style = "fg:#FFFFFF";

      symbols = {
        AlmaLinux = " ";
        Alpaquita = " ";
        Alpine = " ";
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
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        RedHatEnterprise = " ";
        Redhat = " ";
        Redox = "󰀘 ";
        RockyLinux = " ";
        SUSE = " ";
        Solus = "󰠳 ";
        Ubuntu = " ";
        Unknown = " ";
        Void = " ";
        Windows = "󰍲 ";
        openSUSE = " ";
      };
    };

    username = {
      disabled = true;
      format = "[$user ]($style)";
      show_always = true;
      style_root = "fg:#FFFFFF";
      style_user = "fg:#FFFFFF";
    };
  };

  shell_format = "$shlvl$directory";
  shell = {
    shlvl = {
      disabled = false;
      format = "[$shlvl ]($style)";
      style = "fg:#FFFFFF";
      threshold = 5;
    };
    directory = {
      before_repo_root_style = "dimmed blue";
      fish_style_pwd_dir_length = 1;
      format = "[$path ]($style)[$read_only]($read_only_style)";
      read_only = " 󰌾";
      read_only_style = "red";
      repo_root_style = "underline blue";
      style = "fg:blue";
      truncate_to_repo = false;

      substitutions = {
        Documents = "󰈙 ";
        Downloads = " ";
        Music = " ";
        Pictures = " ";
      };
    };
  };

  custom.custom = {
    git_branch = {
      command = "starship module git_branch";
      description = "Only show git_branch if we're not in a jj repo";
      format = "[$symbol$branch ]($style)";
      style = "";
      when = "! ${jj} --ignore-working-copy root";
    };

    git_status = {
      command = "starship module git_status";
      description = "Only show git_status if we're not in a jj repo";
      format = "[$symbol$branch ]($style)";
      style = "";
      when = "! ${jj} --ignore-working-copy root";
    };

    jj = {
      command = ''
        ${jj} log \
          --revisions @ \
          --no-graph \
          --ignore-working-copy \
          --color always \
          --limit 1 \
          --template '
            separate(" ",
              change_id.shortest(4),
              truncate_end(15, bookmarks, "…"),
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
      description = "The current jj status";
      style = "";
      symbol = " ";
      when = "${jj} --ignore-working-copy root";
      ignore_timeout = true;
    };
  };

  vcs = lib.mapAttrs (_: v: vcs_defaults // v) vcs_defs;
  vcs_format = "$fossil_branch$hg_branch$git_branch\${custom.git_branch}$pijul_channel$git_status\${custom.git_status}\${custom.jj}";
  vcs_defaults = {
    style = "fg:green";
  };
  vcs_defs = {
    fossil_branch = {
      format = "[$symbol$branch ]($style)";
      symbol = " ";
    };

    git_branch = {
      disabled = true;
      format = "[$symbol$branch ]($style)";
      symbol = " ";
    };

    git_status = {
      disabled = true;
      format = "[$all_status$ahead_behind ]($style)";
    };
    hg_branch = {
      format = "[$symbol$branch ]($style)";
      symbol = " ";
    };
    pijul_channel = {
      format = "[$symbol$channel ]($style)";
      symbol = " ";
    };
  };

  lang_defs = {
    aws.symbol = "  ";
    buf.symbol = " ";
    c.symbol = " ";
    conda.symbol = " ";
    crystal.symbol = " ";
    dart.symbol = " ";
    elixir.symbol = " ";
    elm.symbol = " ";
    fennel.symbol = " ";
    golang.symbol = " ";
    gradle.symbol = " ";
    haskell.symbol = " ";
    haxe.symbol = " ";
    java.symbol = " ";
    julia.symbol = " ";
    kotlin.symbol = " ";
    lua.symbol = " ";
    nim.symbol = "󰆥 ";
    nodejs.symbol = " ";
    ocaml.symbol = " ";
    package = {
      disabled = true;
      symbol = "󰏗 ";
    };
    perl.symbol = " ";
    php.symbol = " ";
    python.symbol = " ";
    rlang.symbol = "󰟔 ";
    ruby.symbol = " ";
    rust.symbol = " ";
    scala.symbol = " ";
    swift.symbol = " ";
    zig.symbol = " ";
  };
  lang_defaults = {
    format = "[$symbol($version) ]($style)";
    style = "fg:peach";
  };
  langs = lib.mapAttrs (_: l: lang_defaults // l) lang_defs;
  lang_format = lib.concatStrings [
    "$aws"
    "$buf"
    "$c"
    "$conda"
    "$crystal"
    "$dart"
    "$elixir"
    "$elm"
    "$fennel"
    "$golang"
    "$gradle"
    "$haskell"
    "$haxe"
    "$java"
    "$julia"
    "$kotlin"
    "$lua"
    "$nim"
    "$nodejs"
    "$ocaml"
    "$perl"
    "$php"
    "$python"
    "$rlang"
    "$ruby"
    "$rust"
    "$scala"
    "$swift"
    "$zig"
    " "
    "$package"
  ];

  environments = lib.mapAttrs (_: e: environments_defaults // e) environments_defs;
  environments_format = "$direnv$docker_context$guix_shell$meson$nix_shell";
  environments_defaults = {
    style = "fg:mauve";
  };
  environments_defs = {
    direnv = {
      allowed_msg = "";
      denied_msg = "";
      disabled = false;
      format = "[$symbol$loaded/$allowed ]($style)";
      loaded_msg = "";
      not_allowed_msg = "";
      symbol = " ";
      unloaded_msg = "";
    };

    docker_context = {
      format = "[$symbol$context ]($style)";
      symbol = " ";
    };

    guix_shell = {
      format = "[$symbol]($style)";
      symbol = " ";
    };

    meson = {
      format = "[$symbol$project ]($style)";
      symbol = "󰔷 ";
    };

    nix_shell = {
      format = "[$symbol$state ]($style)";
      symbol = " ";
    };
  };
in
{
  scan_timeout = 100;
  format = lib.concatStrings [
    machine_format
    shell_format
    vcs_format
    lang_format
    "$fill"
    "$status"
    environments_format
    "$time\n$character"
  ];

  fill = {
    style = "fg:surface1";
    symbol = "-";
  };

  status = {
    disabled = false;
    format = "[$symbol$status ]($style)";
    style = "";
  };

  time = {
    disabled = false;
    format = "[$time ]($style)";
    style = "fg:overlay1";
    time_format = "%R";
  };
}
// machine
// shell
// vcs
// langs
// environments
// custom
