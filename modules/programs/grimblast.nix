{
  den.aspects.programs.grimblast = {
    homeManager =
      { pkgs, ... }:
      let
        pkg = pkgs.grimblast;
      in
      {
        home.packages = [ pkg ];
        gipphe.core.wm.bind =
          let
            grimblast = "${pkg}/bin/grimblast";
          in
          {
            "SUPER + Print".action.spawn = "${grimblast} copy area";
            "SUPER + Alt_L + Print".action.spawn = "${grimblast} copy screen";
          };
      };
  };
}
