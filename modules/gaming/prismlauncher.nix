{ util, pkgs, ... }:
util.mkGaming {
  name = "prismlauncher";
  homeManager.home.packages = [
    (pkgs.prismlauncher.override {
      jdks = builtins.attrValues {
        inherit (pkgs)
          jdk21
          jdk17
          jdk8
          jdk25
          ;
      };
    })
  ];
}
