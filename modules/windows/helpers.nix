{ lib, ... }:
{
  concatStringsList = xs: lib.concatStringsSep ", " (builtins.map (s: "\"${s}\"") xs);
}
