{pkgs, lib, ...}: let
  host = ["nixos-vm"];
  key = ["gitlab.ssh", "github.ssh", "codeberg.ssh"];
  inherit (lib.attrsets) genAttrs cartesianProductOfSets;
  secretNames = builtins.map (x: "${x.host}-${x.key}") (cartesianProductOfSets { inherit host key; });
  secrets = genAttrs (sn: { file = ../secrets/${sn}.age; owner = "gipphe"; group = "gipphe"; }) secretNames;
in {
  age.secrets = secrets;
}
