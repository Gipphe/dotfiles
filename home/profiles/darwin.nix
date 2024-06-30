{ util, ... }:
util.mkProfile "darwin" {
  gipphe.programs = {
    alt-tab.enable = true;
    homebrew.enable = true;
    karabiner-elements.enable = true;
    linearmouse.enable = true;
    xnviewmp.enable = true;
  };
}
