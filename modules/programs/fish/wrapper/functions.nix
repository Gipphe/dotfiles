{
  lib,
  config,
  ...
}:
let
  functionModule = lib.types.submodule {
    options = {
      body = lib.mkOption {
        type = lib.types.lines;
        description = ''
          The function body.
        '';
      };

      argumentNames = lib.mkOption {
        type = with lib.types; nullOr (either str (listOf str));
        default = null;
        description = ''
          Assigns the value of successive command line arguments to the names
          given.
        '';
      };

      description = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          A description of what the function does, suitable as a completion
          description.
        '';
      };

      wraps = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Causes the function to inherit completions from the given wrapped
          command.
        '';
      };

      onEvent = lib.mkOption {
        type = with lib.types; nullOr (either str (listOf str));
        default = null;
        description = ''
          Tells fish to run this function when the specified named event is
          emitted. Fish internally generates named events e.g. when showing the
          prompt.
        '';
      };

      onVariable = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Tells fish to run this function when the specified variable changes
          value.
        '';
      };

      onJobExit = lib.mkOption {
        type = with lib.types; nullOr (either str int);
        default = null;
        description = ''
          Tells fish to run this function when the job with the specified group
          ID exits. Instead of a PID, the stringer `caller` can
          be specified. This is only legal when in a command substitution, and
          will result in the handler being triggered by the exit of the job
          which created this command substitution.
        '';
      };

      onProcessExit = lib.mkOption {
        type = with lib.types; nullOr (either str int);
        default = null;
        example = "$fish_pid";
        description = ''
          Tells fish to run this function when the fish child process with the
          specified process ID exits. Instead of a PID, for backwards
          compatibility, `%self` can be specified as an alias
          for `$fish_pid`, and the function will be run when
          the current fish instance exits.
        '';
      };

      onSignal = lib.mkOption {
        type = with lib.types; nullOr (either str int);
        default = null;
        example = [
          "SIGHUP"
          "HUP"
          1
        ];
        description = ''
          Tells fish to run this function when the specified signal is
          delivered. The signal can be a signal number or signal name.
        '';
      };

      noScopeShadowing = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Allows the function to access the variables of calling functions.
        '';
      };

      inheritVariable = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Snapshots the value of the specified variable and defines a local
          variable with that same name and value when the function is defined.
        '';
      };
    };
  };
in
{
  options.functions = lib.mkOption {
    type = with lib.types; attrsOf (either lines functionModule);
    default = { };
    example = lib.literalExpression /* nix */ ''
      {
        __fish_command_not_found_handler = {
          body = "__fish_default_command_not_found_handler $argv[1]";
          onEvent = "fish_command_not_found";
        };

        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      }
    '';
    description = ''
      Basic functions to add to fish. For more information see
      <https://fishshell.com/docs/current/cmds/function.html>.
    '';
  };

  config.init.internal.sourceHandlersStr =
    let
      handlerAttrs = [
        "onJobExit"
        "onProcessExit"
        "onVariable"
        "onSignal"
        "onEvent"
      ];
      isHandler =
        name: def: lib.isAttrs def && builtins.any (attr: builtins.hasAttr attr def) handlerAttrs;
      handlerFunctions = lib.filterAttrs isHandler config.functions;
      sourceFunction =
        name: def: "source ${placeholder "out"}/${config.configDir}/functions/${name}.fish";
    in
    builtins.concatStringsSep "\n" (lib.mapAttrsToList sourceFunction handlerFunctions);

  config.constructFiles = lib.mapAttrs' (name: def: {
    name = "fish-function-${name}}";
    value = {
      relPath = "${config.configDir}/functions/${name}.fish";
      content =
        let
          modifierStr = n: v: lib.optional (v != null) ''--${n}="${toString v}"'';
          modifierStrs = n: v: lib.optional (v != null) "--${n}=${toString v}";
          modifierBool = n: v: lib.optional (v != null && v) "--${n}";

          mods =
            modifierStr "description" def.description
            ++ modifierStr "wraps" def.wraps
            ++ lib.concatMap (modifierStr "on-event") (lib.toList def.onEvent)
            ++ modifierStr "on-variable" def.onVariable
            ++ modifierStr "on-job-exit" def.onJobExit
            ++ modifierStr "on-process-exit" def.onProcessExit
            ++ modifierStr "on-signal" def.onSignal
            ++ modifierBool "no-scope-shadowing" def.noScopeShadowing
            ++ modifierStr "inherit-variable" def.inheritVariable
            ++ modifierStrs "argument-names" def.argumentNames;

          modifiers = if lib.isAttrs def then " ${toString mods}" else "";
          body = if lib.isAttrs def then def.body else def;
        in
        ''
          function ${name}${modifiers}
            ${lib.strings.removeSuffix "\n" body}
          end
        '';
    };
  }) config.functions;
}
