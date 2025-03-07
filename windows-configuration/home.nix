{
  lib,
  config,
  pkgs,
  util,
  ...
}:
let
  processFile = path: file: 
in
{
  config.windows.profile = {
    home.file = lib.mapAttrs' (path: file:
    let
      processed = processFile path file;
    in if processed != null then processed else {
      name = path;
      value = file;
    };
  };
}
