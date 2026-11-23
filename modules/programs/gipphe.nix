{
  den.aspects.programs.gipphe.homeManager =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.gipphe.programs.gipphe;
      commandToFunc = { name, value }: commandToFunc' [ "gipphe" name ] value;
      commandToFunc' =
        subCommand: value:
        if (value ? __isCmd) && value.__isCmd then
          lib.optionalString (value.doc or null != null) /* nu */ ''
            # ${value.doc}
          ''
          + /* nu */ ''
            export def --wrapped "${lib.concatStringsSep " " subCommand}" [ ...args ] {
              run-external '${value.cmd}' ...$args
            }
          ''
        else
          /* nu */ ''
            ${lib.concatStringsSep "\n" (
              map ({ name, value }: commandToFunc' (subCommand ++ [ name ]) value) (lib.attrsToList value)
            )}
          '';
      pkg = pkgs.writeTextFile {
        name = "gipphe";
        destination = "/gipphe.nu";
        text = /* nu */ ''
          export def gipphe []: nothing -> nothing {}

          ${lib.concatStringsSep "\n" (map commandToFunc (lib.attrsToList cfg.commands))}
        '';
      };
    in
    {
      options.gipphe.programs.gipphe = {
        commands = lib.mkOption {
          description = "Commands to add to gipphe executable";
          default = { };
          type =
            with lib.types;
            let
              command = addCheck command' (value: !lib.isDerivation value) // {
                description = "command or attribute set of commands (not a derivation)";
              };
              command' = oneOf [
                (addCheck (submodule {
                  options.doc = lib.mkOption {
                    type = nullOr str;
                    description = "Description for the command";
                    default = null;
                  };
                  options.cmd = lib.mkOption {
                    type = either path str;
                    description = "Command to execute";
                  };
                  options.__isCmd = lib.mkOption {
                    type = bool;
                    default = true;
                    internal = true;
                    readOnly = true;
                    description = "Marker to distinguish commands from other attrsets";
                  };
                }) (v: !lib.isDerivation v && v ? cmd))
                (attrsOf command)
              ];
            in
            attrsOf command;
        };
      };

      config.programs.nushell.extraConfig = lib.mkIf (cfg.commands != { }) /* nu */ ''
        source `${pkg}/gipphe.nu`
      '';
    };
}
