{ pkgs, lib, config, ... }:
with builtins;
with lib.attrsets; {
  home.packages = with pkgs; [ procps ];

  programs.starship = {
    enable = false;
    enableTransience = true;
    settings = {
      aws = {
        format =
          "[$symbol($profile )(\\($region\\) )(\\[$duration\\] )]($style)";
        symbol = "󰸏 ";
      };
      azure = {
        format = "[$symbol($subscription)]($style) ";
        symbol = " ";
      };
      battery = {
        full_symbol = "󱊣 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰁾 ";
        unknown_symbol = "󰂑 ";
        empty_symbol = "󰂃 ";
      };
      buf = { format = "[$symbol($version )]($style)"; };
      bun = { format = "[$symbol($version )]($style)"; };
      c = {
        format = "[$symbol($version(-$name) )]($style)";
        symbol = " ";
      };
      cmake = {
        format = "[$symbol($version )]($style)";
        symbol = "󰇂 ";
      };
      cobol = { format = "[$symbol($version )]($style)"; };
      conda = { format = "[$symbol$environment]($style)"; };
      container = {
        format = "[$symbol [$name]]($style)";
        symbol = "";
      };
      crystal = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      daml = { format = "[$symbol($version )]($style)"; };
      dart = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      deno = { format = "[$symbol($version )]($style)"; };
      direnv = {
        format = "[$symbol$loaded/$allowed]($style)";
        symbol = " ";
      };
      docker_context = {
        format = "[$symbol$context]($style)";
        symbol = " ";
      };
      dotnet = {
        format = "[$symbol($version )(󰣉 $tfm )]($style)";
        symbol = "󰪮 ";
      };
      elixir = {
        format = "[$symbol($version (OTP $otp_version) )]($style)";
        symbol = " ";
      };
      elm = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      erlang = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      fennel = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      fossil_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };
      gcloud = { disabled = true; };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style)";
        symbol = " ";
      };
      golang = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      guix_shell = {
        format = "[$symbol]($style)";
        symbol = " ";
      };
      gradle = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      haskell = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      haxe = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      helm = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      hostname = { format = "[$ssh_symbol$hostname]($style)"; };
      java = {
        format = "\${symbol}";
        symbol = " ";
      };
      jobs = { format = "[$symbol$number]($style)"; };
      julia = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      kotlin = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      kubernetes = {
        format = "[$symbol$context( ($namespace))]($style)";
        symbol = "󱃾 ";
      };
      lua = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      meson = { format = "[$symbol$project]($style)"; };
      hg_branch = {
        format = "[$symbol$branch(:$topic)]($style)";
        symbol = " ";
      };
      nim = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "󱄅 ";
      };
      nodejs = {
        format = "[$symbol($version )]($style)";
        symbol = "󰎙 ";
      };
      ocaml = {
        format =
          "[$symbol($version )(\\($switch_indicator$switch_name\\) )]($style)";
        symbol = " ";
      };
      opa = { format = "[$symbol($version )]($style)"; };
      openstack = { format = "[$symbol$cloud(\\($project\\))]($style)"; };
      package = { format = "[$symbol$version]($style)"; };
      perl = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      php = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      pijul_channel = { format = "[$symbol$channel]($style)"; };
      pulumi = { format = "[$symbol($username@)$stack]($style)"; };
      purescript = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      python = {
        format =
          "[\${symbol}\${pyenv_prefix}(\${version} )(($virtualenv) )]($style)";
        symbol = " ";
      };
      rlang = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      raku = { format = "[$symbol($version-$vm_version )]($style)"; };
      red = { format = "[$symbol($version )]($style)"; };
      ruby = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      rust = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      scala = {
        format = "[\${symbol}(\${version} )]($style)";
        symbol = " ";
      };
      solidity = { format = "[$symbol($version )]($style)"; };
      spack = { format = "[$symbol$environment]($style)"; };
      swift = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      terraform = {
        format = "[$symbol$workspace]($style)";
        symbol = " ";
      };
      typst = { format = "[$symbol($version )]($style)"; };
      username = { format = "[$user]($style)"; };
      vagrant = { format = "[$symbol($version )]($style)"; };
      vlang = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      zig = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.fish = {
    enable = true;
    shellInit = readFile ./config.fish;
    package = pkgs.fish;
    functions = let
      function_files = filterAttrs (f: t: t == "regular") (readDir ./functions);
      function_list = attrNames function_files;
      functions = foldl' (fs: f:
        let fname = head (split "\\.fish$" f);
        in fs // { ${fname} = readFile ./functions/${f}; }) { } function_list;
    in functions;
    shellAbbrs = {
      hms =
        "home-manager switch --flake ${config.home.homeDirectory}/projects/dotfiles";
      set_tide_prompt =
        "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Solid --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=Yes";
    };
    plugins = with pkgs; [
      # {
      #   name = "tide";
      #   src = fishPlugins.tide.src;
      # }
      {
        name = "bass";
        src = fishPlugins.bass.src;
      }
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "57afe578d36110615df6c8ce9165d9971e271063";
          sha256 = "sha256-dw6XLjtaOF7jVAsMqH+CZJFpy20o3gc85A8CQWe/N/8=";
        };
      }
      {
        name = "nix";
        src = pkgs.fetchFromGitHub {
          owner = "kidonng";
          repo = "nix.fish";
          rev = "master";
          sha256 = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
        };
      }
    ];
  };
}
