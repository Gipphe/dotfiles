{ pkgs, ... }:
pkgs.fetchurl {
  url = "https://github.com/karimould/zellij-forgot/releases/download/0.3.0/zellij_forgot.wasm";
  hash = "sha256-JNQ4KXb6VzjSF0O4J8Tvq3FXUYBBabQb9ZitcR3kZFw=";
}
