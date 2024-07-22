{ pkgs, ... }:
(import ./pkg {
  pkgs = pkgs;
  inherit (pkgs) system;
  nodejs = pkgs.nodejs_20;
})."@dataform/cli"
