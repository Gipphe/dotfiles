{
  config,
  lib,
  util,
  ...
}:
let
  inherit (lib)
    attrsToList
    filter
    hasSuffix
    listToAttrs
    map
    mkIf
    pipe
    ;
  inherit (builtins) readDir;
  cssFiles = pipe ./. [
    readDir
    attrsToList
    (filter (f: f.value == "regular"))
    (map (f: f.name))
    (filter (hasSuffix ".css"))
    (map (f: {
      name = "vivaldi/cssMods/${f}";
      value.source = ./${f};
    }))
    listToAttrs
  ];
in
util.mkModule {
  hm = mkIf config.gipphe.programs.vivaldi.enable {
    xdg.configFile = cssFiles;
    gipphe.windows.home.file = lib.mapAttrs' (name: value: {
      name = ".config/${name}";
      inherit value;
    }) cssFiles;
  };
}
