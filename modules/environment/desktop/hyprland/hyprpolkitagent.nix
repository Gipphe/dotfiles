{ util, ... }:
util.mkModule {
  hm.config = {
    servies.hyprpolkitagent.enable = true;
  };
}
