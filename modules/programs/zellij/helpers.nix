{ lib, ... }:
{
  unbind = keys: {
    "unbind \"${keys}\"" = [ ];
  };
  bind = keys: opts: { "bind \"${keys}\"" = opts; };
  section = section: opts: { "${section}" = opts; };
  shared_except = modes: opts: { "shared_except \"${lib.concatStringsSep "\" \"" modes}\"" = opts; };
}
