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
in
util.mkModule {
  hm = mkIf config.gipphe.programs.vivaldi.enable {
    xdg.configFile = pipe ./. [
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
  };
}
