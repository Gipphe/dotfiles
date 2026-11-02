{ den, ... }: {
  den.aspects.programs._1password-cli = {
    includes = [ (den.batteries.unfree [ "1password-cli" ]) ];
    nixos.programs._1password.enable = true;
  };
}
