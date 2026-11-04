{
  den.aspects.programs.greetd.nixos = { pkgs, ... }: {
    services.greetd = {
      enable = true;
      package = pkgs.greetd.wlgreet;
    };
  };
}
