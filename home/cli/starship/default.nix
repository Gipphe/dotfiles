{ ... }: {
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
}
