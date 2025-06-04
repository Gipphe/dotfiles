{ util, ... }:
util.mkModule {
  hm.config = {
    services.hyprpolkitagent.enable = true;
  };
}
