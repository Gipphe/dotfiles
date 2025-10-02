{ util, ... }:
util.mkProfile {
  name = "cli-extra";
  shared.gipphe.programs = {
    fastgron.enable = true;
    fzf.enable = true;
    make.enable = true;
    pay-respects.enable = true;
    procs.enable = true;
    pv.enable = true;
  };
}
