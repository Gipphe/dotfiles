{ pkgs, ... }:
pkgs.fetchurl {
  url = "https://github.com/rvcas/room/releases/download/v1.1.1/room.wasm";
  hash = "sha256-wCGnvFaoaoyH6QFkIqaDj0j0lGe1DOAX4ZmUQOyT/eY=";
}
