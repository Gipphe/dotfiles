{
  den.aspects.programs.starship.homeManager =
    { lib, pkgs, ... }:
    {
      programs.starship = {
        enable = true;
        enableTransience = true;
        settings = import ./_preset.nix {
          inherit lib;
          inherit (pkgs) jujutsu fetchFromGitHub writeShellScript;
        };
      };
    };
}
