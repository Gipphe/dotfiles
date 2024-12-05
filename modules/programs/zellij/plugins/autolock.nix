{ pkgs, ... }:
pkgs.fetchurl {
  url = "https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.1/zellij-autolock.wasm";
  hash = "sha256-w0/tuThhDa+YaxqzUrGvovgZKNM+vSkQC7/FxmSWf8o=";
}
