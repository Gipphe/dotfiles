{ inputs, ... }: {
  den.quirks.nushell-abbrs.description = "Abbreviations";
  den.aspects.programs.nushell.homeManager =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.programs.nushell;
    in
    {
      programs = {
        bash = {
          enable = true;
          initExtra = ''
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]; then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${cfg.package}/bin/nu $LOGIN_OPTION
            fi
          '';
        };

        nushell = {
          enable = true;
          # TODO: Remove once nushell 0.117.0 is in nixos-unstable.
          # See https://nixpk.gs/pr-tracker.html?pr=586153
          package = inputs.nixpkgs-nushell.legacyPackages.${pkgs.stdenv.hostPlatform.system}.nushell;
          envFile.text = /* nu */ ''
            $env.TRANSIENT_PROMPT_COMMAND = ^starship module character
            $env.TRANSIENT_PROMPT_INDICATOR = ""
            $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = ""
            $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = ""
            $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""
            $env.TRANSIENT_PROMPT_COMMAND_RIGHT = ^starship module time
          '';
          # TODO: Use nushell 0.117.0's new `generate completions` command to
          # generate completions from carapace and fish completions.
          extraConfig = /* nu */ ''
            use std/dirs
          '';
          loadSessionVariables = true;
          settings.abbreviations.rm = "rm -i";
          settings = {
            edit_mode = "vi";
            show_banner = false;
            max_last_result_size = lib.hm.nushell.mkNushellInline "10mb";
          };
        };
      };
    };
}
