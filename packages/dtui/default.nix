{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "dtui";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "Troels51";
    repo = "dtui";
    rev = "16905326a9ce5d219992bda48f5fbde4ce68b4e2";
    hash = "sha256-QHMkOlymLi57MLS5J/8vLJwMcyxDVLKfJC4s0RZ60nU=";
  };

  cargoHash = "sha256-rI4twKo2YdIiWCNXPhEe/rexxtpeM4CS1aDo4zpLHdg=";

  meta = {
    description = "Small TUI for introspecting the state of the system/session dbus";
    homepage = "https://github.com/Troels51/dtui";
    license = lib.licenses.unlicense;
    maintainers = [ ];
  };
}
