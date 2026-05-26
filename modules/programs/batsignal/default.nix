{ util, ... }:
util.mkProgram {
  name = "batsignal";
  homeManager.services.batsignal = {
    enable = true;
  };
}
