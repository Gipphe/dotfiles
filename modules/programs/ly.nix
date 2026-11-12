{
  den.aspects.programs.ly.nixos = {
    services.displayManager = {
      enable = true;
      ly = {
        enable = true;
        x11Support = false;
        settings = {
          animation = "matrix";
        };
      };
    };
  };
}
