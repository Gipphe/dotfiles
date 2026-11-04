{
  den.aspects.programs.sddm.nixos = { user }: {
    services.displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = user.userName;
      };
    };
  };
}
