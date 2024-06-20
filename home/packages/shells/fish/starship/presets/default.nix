{ pkgs, lib, ... }:
let
  starshipper = import ./starshipper.nix { inherit lib; };
  tide-like = import ./tide-like.nix { inherit lib; };
  inherit (starshipper.mkStarship tide-like) format settings;

  flavour = "macchiato";
in
{
  format = "${format}\n$character";
  palette = "catppuccin_${flavour}";
}
// (builtins.fromTOML (
  builtins.readFile (
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "starship";
      rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
      sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
    }
    + /palettes/${flavour}.toml
  )
))
// settings
