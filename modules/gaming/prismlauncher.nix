{
  den.aspects.gaming.prismlauncher.homeManager = { pkgs, ... }: {
    home.packages = [
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
  };
}
