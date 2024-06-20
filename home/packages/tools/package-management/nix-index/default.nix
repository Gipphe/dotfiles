{ inputs, ... }:
{
  imports = [ inputs.nix-index.hmModule.nix-index ];
  config = {
    programs.nix-index-database = {
      comma.enable = true;
    };
  };
}
