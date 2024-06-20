{
  flags,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ./audio
    ./programs
    ./cli
    ./core
    ./darwin.nix
    ./desktop
    ./services
    ./term.nix
    ./theme.nix
    ./work
  ] ++ (lib.optionals flags.system.isNixDarwin [ inputs.mac-app-util.homeManagerModules.default ]);
}
