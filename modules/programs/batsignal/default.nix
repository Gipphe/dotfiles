{ util, ... }:
util.mkProgram {
  name = "batsignal";
  home-manager.services.batsignal = {
    enable = true;
  };
}
