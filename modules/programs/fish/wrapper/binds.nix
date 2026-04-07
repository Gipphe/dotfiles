{ lib, config, ... }:
let
  filteredBinds = lib.filterAttrs (_: { enable, ... }: enable) config.binds;
  bindModule = lib.types.submodule (
    { config, ... }:
    {
      options = {
        name = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          description = ''
            The key name that is used for the bind.
            If null, the attribute set key is used.
          '';
        };
        enable = lib.mkEnableOption "enable the bind. Set false if you want to ignore the bind" // {
          default = true;
        };
        mode = lib.mkOption {
          description = "Specify the bind mode that the bind is used in";
          type =
            with lib.types;
            nullOr (
              either (enum [
                "default"
                "insert"
                "paste"
              ]) str
            );
          default = null;
        };
        command = lib.mkOption {
          description = "command that will be execute";
          type =
            let
              origin =
                with lib.types;
                nullOr (oneOf [
                  str
                  (listOf str)
                ]);
            in
            origin
            // {
              description = "string or list of string (optional when erase is set to true)";
              check = x: if !config.erase && isNull x then false else origin.check x;
            };
          default = null;
        };
        setsMode = lib.mkOption {
          description = "Change current mode after bind is executed";
          type =
            with lib.types;
            nullOr (
              either (enum [
                "default"
                "insert"
                "paste"
              ]) str
            );
          default = null;
        };
        erase = lib.mkEnableOption "remove bind";
        silent = lib.mkEnableOption "Operate silently";
        repaint = lib.mkEnableOption "redraw prompt after command";
        operate = lib.mkOption {
          description = "Operate on preset bindings or user bindings";
          type =
            with lib.types;
            nullOr (enum [
              "preset"
              "user"
            ]);
          default = null;
        };
      };
    }
  );
  bindsStr = lib.concatStringsSep "\n" (
    lib.flatten (
      lib.mapAttrsToList (
        k:
        {
          name,
          silent,
          erase,
          repaint,
          operate,
          mode,
          setsMode,
          command,
          ...
        }:
        let
          key = if name != null then name else k;
          opts =
            lib.optionals silent [ "-s" ]
            ++ lib.optionals (!isNull operate) [ "--${operate}" ]
            ++ lib.optionals (!isNull mode) [
              "--mode"
              mode
            ]
            ++ lib.optionals (!isNull setsMode) [
              "--sets-mode"
              setsMode
            ];

          cmdNormal = lib.concatStringsSep " " (
            [ "bind" ]
            ++ opts
            ++ [ key ]
            ++ map lib.escapeShellArg (lib.flatten [ command ])
            ++ lib.optional repaint "repaint"
          );

          cmdErase = lib.concatStringsSep "  " (
            [
              "bind"
              "-e"
            ]
            ++ opts
            ++ [ key ]
          );
        in
        lib.optionals erase [ cmdErase ] ++ lib.optionals (!isNull command) [ cmdNormal ]
      ) filteredBinds
    )
  );
in
{
  options.binds = lib.mkOption {
    type = lib.types.attrsOf bindModule;
    default = { };
    description = "Manage key bindings";
    example =
      lib.literalExpression # nix
        ''
          {
            "alt-shift-b".command = "fish_commandline_append bat";
            "alt-s".erase = true;
            "alt-s".operate = "preset";
          }
        '';
  };
  config = lib.mkIf (filteredBinds != { }) {
    functions.fish_user_key_bindings = bindsStr;
  };
}
