{ util, ... }:
util.mkProfile "ai" {
  gipphe.programs = {
    mods.enable = true;
    # Does not work properly yet.
    tlm.enable = false;
  };
}
