{
  den.aspects.programs.godot.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.godot_4-mono ];
  };
}
