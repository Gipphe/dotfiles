{ lib, ... }:
let
  helpers = {
    unbind = keys: {
      "unbind \"${keys}\"" = [ ];
    };
    bind = keys: opts: { "bind \"${keys}\"" = opts; };
    section = section: opts: { "${section}" = opts; };
    shared_except = modes: opts: { "shared_except \"${lib.concatStringsSep "\" \"" modes}\"" = opts; };
  };
in
{
  options.gipphe.lib.zellij = lib.mkOption {
    description = "Helper functions for working with Zellij";
    default = helpers;
    type = lib.types.anything;
    internal = true;
  };
}
