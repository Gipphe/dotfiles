{ pkgs, ... }:
pkgs.fetchurl {
  url = "https://github.com/cristiand391/zj-status-bar/releases/download/0.3.0/zj-status-bar.wasm";
  hash = "sha256-seiWCtsrkFnDwXrXrAOE6y9EUWzpnb8qgHqRDdMKCeg=";
}
