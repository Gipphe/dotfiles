{
  lib,
  config,
  pkgs,
  ...
}:
let
  abbrModule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          The abbreviation name that is replaced by the expansion.
        '';
      };

      expansion = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          The command expanded by an abbreviation.
        '';
      };

      position = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        example = "anywhere";
        description = ''
          If the position is "command", the abbreviation expands only if
          the position is a command. If it is "anywhere", the abbreviation
          expands anywhere.
        '';
      };

      regex = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          The regular expression pattern matched instead of the literal name.
        '';
      };

      command = lib.mkOption {
        type = with lib.types; nullOr (either str (listOf str));
        default = null;
        description = ''
          Specifies the command(s) for which the abbreviation should expand. If
          set, the abbreviation will only expand when used as an argument to
          the given command(s).
        '';
      };

      setCursor = lib.mkOption {
        type = with lib.types; (either bool str);
        default = false;
        description = ''
          The marker indicates the position of the cursor when the abbreviation
          is expanded. When setCursor is true, the marker is set with a default
          value of "%".
        '';
      };

      function = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          The fish function expanded instead of a literal string.
        '';
      };
    };
  };

  abbrsStr = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      attrName: def:
      let
        name = if lib.isAttrs def && def.name != null then def.name else attrName;
        mods =
          lib.cli.toCommandLineShell
            (optionName: {
              option = "--${optionName}";
              sep = if optionName == "set-cursor" then "=" else null;
              explicitBool = false;
              formatArg = lib.generators.mkValueStringDefault { };
            })
            {
              inherit (def)
                position
                regex
                command
                function
                ;
              set-cursor = def.setCursor;
            };
        modifiers = if lib.isAttrs def then mods else "";
        expansion = if lib.isAttrs def then def.expansion else def;
      in
      "abbr --add ${modifiers} -- ${name}"
      + lib.optionalString (expansion != null) " ${lib.escapeShellArg expansion}"
    ) config.init.shellAbbrs
  );
  aliasesStr = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (k: v: "alias ${k} ${lib.escapeShellArg v}") config.init.shellAliases
  );
in
{
  options = {
    sessionVariablesFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      example = lib.literalExpression /* nix */ ''
        ''${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh
      '';
      description = ''
        Path to session variables file from the system or from home-manager.
        Will be parsed into session variables for fish.
      '';
    };

    init = {
      internal = {
        sourceHandlersStr = lib.mkOption {
          type = lib.types.lines;
          default = "";
          internal = true;
        };
      };

      shellAliases = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        example = lib.literalExpression /* nix */ ''
          {
            g = "git";
            "..." = "cd ../..";
          }
        '';
        description = ''
          An attribute set that maps aliases (the top level attribute names
          in this option) to command strings or directly to build outputs.
        '';
      };
      shellAbbrs = lib.mkOption {
        type = with lib.types; attrsOf (either str abbrModule);
        default = { };
        example = lib.literalExpression /* nix */ ''
          {
            l = "less";
            gco = "git checkout";
            "-C" = {
              position = "anywhere";
              expansion = "--color";
            };
          }
        '';
        description = ''
          An attribute set that maps aliases (the top level attribute names
          in this option) to abbreviations. Abbreviations are expanded with
          the longer phrase after they are entered.
        '';
      };

      preferAbbrs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = ''
          If enabled, abbreviations will be preferred over aliases when
          other modules define aliases for fish.
        '';
      };

      shell = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Shell script code called during fish shell
          initialisation.
        '';
      };

      loginShell = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Shell script code called during fish login shell
          initialisation.
        '';
      };

      interactiveShell = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Shell script code called during interactive fish shell
          initialisation.
        '';
      };

      shellLast = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Shell script code called during interactive fish shell
          initialisation, this will be the last thing executed in fish startup.
        '';
      };
    };
  };
  config.constructFiles.config = {
    relPath = "${config.configDir}/config.fish";
    content = ''
      # ~/.config/fish/config.fish: DO NOT EDIT -- this file has been generated
      # automatically by fish wrapper.

      # Only execute this file once per shell.
      set -q __fish_wrapped_config_sourced; and exit
      set -g __fish_wrapped_config_sourced 1

      ${lib.optionalString (config.sessionVariablesFile != null) ''
        ${pkgs.buildPackages.babelfish}/bin/babelfish <${config.sessionVariablesFile}
      ''}

      # Source handler functions
      ${config.init.internal.sourceHandlersStr}

      ${config.init.shell}

      status is-login; and begin

        # Login shell initialisation
        ${config.init.loginShell}

      end

      status is-interactive; and begin

        # Abbreviations
        ${abbrsStr}

        # Aliases
        ${aliasesStr}

        # Interactive shell initialisation
        ${config.init.interactiveShell}

      end

      ${config.init.shellLast}
    '';
  };
}
