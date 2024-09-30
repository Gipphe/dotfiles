{ util, ... }:
util.mkProfile "rice-darwin" {
  gipphe = {
    profiles.rice.enable = true;
    programs = {
      yabai.enable = true;
      skhd.enable = true;
    };
  };
}
