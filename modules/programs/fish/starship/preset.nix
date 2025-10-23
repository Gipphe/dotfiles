{
  lib,
  fetchFromGitHub,
  jujutsu,
  ...
}:
let
  flavour = "macchiato";
  catppuccin-starship = fetchFromGitHub {
    owner = "catppuccin";
    repo = "starship";
    rev = "5906cc369dd8207e063c0e6e2d27bd0c0b567cb8";
    sha256 = "sha256-FLHjbClpTqaK4n2qmepCPkb8rocaAo3qeV4Zp1hia0g=";
  };
  catppuccin-starship-macchiato = lib.pipe "${catppuccin-starship}/themes/${flavour}.toml" [
    builtins.readFile
    builtins.fromTOML
  ];
  palette.palette = lib.mkForce "catppuccin_${flavour}";

  tide-like = import ./tide-like.nix {
    inherit lib jujutsu;
  };
in
tide-like // palette // catppuccin-starship-macchiato
