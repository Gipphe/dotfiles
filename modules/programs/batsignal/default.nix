{ util, ... }:
util.mkProgram {
  name = "batsignal";
  hm.services.batsignal = {
    enable = true;
  };
}
