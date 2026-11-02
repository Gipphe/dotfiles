{
  den.aspects.programs.git.diff-so-fancy.homeManager = { pkgs, lib, ... }: {
    gipphe.programs.git.settings =
      let
        dsf = lib.getExe pkgs.diff-so-fancy;
      in
      {
        core.pager = "${dsf} | ${lib.getExe pkgs.less} --tabs=4 -RFX";
        interactive.diffFilter = "${dsf} --patch";
        diff-so-fancy = { };
      };
    home.packages = [ pkgs.diff-so-fancy ];
  };
}
