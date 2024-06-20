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
    ./cli
    ./core
    ./desktop
    ./services
    ./theme.nix
    ./work
    ./term.nix
  ] ++ (lib.optionals flags.system.isNixDarwin [ inputs.mac-app-util.homeManagerModules.default ]);
}
