# Statix with pipe-operators support
{
  fetchFromGitHub,
  rustPlatform,
  lib,
  withJson ? true,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "statix";
  version = "support-pipe-operator";
  src = fetchFromGitHub {
    owner = "RobWalt";
    repo = "statix";
    rev = "support-pipe-operator";
    hash = "sha256-KhopZsdYGpLDs9x9fd09B2p//RBelJDgwq20wsm69Bc=";
  };
  cargoHash = "sha256-Jkp5e0TOKTTpLEAvxPp/UNQATmxOfSJgaakdPM3IidA=";
  buildFeatures = lib.optional withJson "json";
  doCheck = !stdenv.hostPlatform.isDarwin;
  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/nerdypepper/statix";
    license = licenses.mit;
    mainProgram = "statix";
    maintainers = with maintainers; [
      figsoda
      nerdypepper
    ];
  };
}
