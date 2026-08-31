{
  config,
  util,
  lib,
  ...
}:
let
  inherit (builtins)
    attrNames
    head
    length
    concatStringsSep
    isAttrs
    ;
  toLua = lib.generators.toLua { };
  cfg = config.gipphe.programs.hyprland;
  dispatcherArgType =
    with lib.types;
    oneOf [
      int
      float
      str
      path
      bool
      (attrsOf dispatcherArgType)
      (listOf dispatcherArgType)
      luaInline
    ]
    // {
      description = "Lua value";
    };
  dispatchType =
    with lib.types;
    submodule {
      options.dispatch = lib.mkOption {
        description = "Dispatcher to use";
        type =
          let
            dspType = attrsOf (either dspType (listOf dispatcherArgType));
          in
          dspType;
      };
    };
  bindType =
    with lib.types;
    attrsOf (submodule {
      options = {
        action = lib.mkOption {
          description = "Action to perform on keybind";
          type = oneOf [
            luaInline
            dispatchType
          ];
        };
        opts = lib.mkOption {
          description = "Other options to pass to the key bind registration";
          default = { };
          type =
            let
              bindOpt = oneOf [
                str
                int
                float
                bool
                path
                (attrsOf bindOpt)
                (listOf bindOpt)
              ];
            in
            attrsOf bindOpt;
        };
      };
    });
  resolveAction =
    action:
    if builtins.isAttrs action && action ? dispatch then
      resolveDispatcher "" action.dispatch
    else
      action;
  resolveDispatcher =
    prefix: dispatch:
    let
      dispatchers = attrNames dispatch;
      dispatcher = head dispatchers;
      args = dispatch.${dispatcher};
    in
    if length dispatchers != 1 then
      throw ("More than 1 dispatcher specified: " ++ concatStringsSep ", " dispatchers)
    else if isAttrs args then
      resolveDispatcher "${prefix}${dispatcher}." args
    else
      lib.mkLuaInline "hl.dsp.${prefix}${dispatcher}(${concatStringsSep ", " (map toLua args)})";
  mkNiceBinds =
    binds:
    map ({ name, value }: {
      _args = [
        name
        (resolveAction value.action)
      ]
      ++ lib.optional (value.opts != { }) value.opts;
    }) (lib.attrsToList binds);
in
util.mkModule {
  shared.options.gipphe.programs.hyprland = {
    settings.bind = lib.mkOption {
      description = "Key bindings";
      default = { };
      type = bindType;
    };
    submaps = lib.mkOption {
      description = "Submap key bindings";
      default = { };
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            onDispatch = lib.mkOption {
              description = "Submap to use after dispatch";
              type = str;
              default = "";
            };
            settings.bind = lib.mkOption {
              description = "Binds for the submap";
              default = { };
              type = bindType;
            };
          };
        });
    };
  };
  homeManager = {
    wayland.windowManager.hyprland = {
      settings.bind = mkNiceBinds cfg.settings.bind;
      submaps = lib.mapAttrs (_: v: {
        inherit (v) onDispatch;
        settings.bind = mkNiceBinds (v.settings.bind or { });
      }) cfg.submaps;
    };
  };
}
