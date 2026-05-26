{ util, ... }:
util.mkProfile {
  name = "cli-extra";
  shared.gipphe.programs = {
    fastgron.enable = true;
    fzf.enable = true;
    hygg.enable = true;
    pay-respects.enable = true;
    procs.enable = true;
  };
}
