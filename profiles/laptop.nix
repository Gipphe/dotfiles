{ util, ... }:
util.mkProfile {
  name = "laptop";
  shared.gipphe.programs = {
    batsignal.enable = true;
  };
}
