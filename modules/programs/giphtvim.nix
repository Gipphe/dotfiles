{ den, inputs, ... }: {
  den.aspects.programs.giphtvim = {
    base.homeManager = {
      home.sessionVariables.EDITOR = "nvim";
      programs.nushell.settings.abbreviations.vim = "nvim";
    };
    full = {
      includes = [ den.aspects.programs.giphtvim.base ];
      homeManager =
        { pkgs, ... }:
        let
          giphtvim = inputs.giphtvim.packages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          home.packages = [ giphtvim.neovim ];
        };
      excludes = [ den.aspects.programs.giphtvim.droid ];
    };
    droid = {
      includes = [ den.aspects.programs.giphtvim.base ];
      homeManager =
        { pkgs, ... }:
        let
          giphtvim = inputs.giphtvim.packages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          home.packages = [ giphtvim.droid ];
        };
      excludes = [ den.aspects.programs.giphtvim.full ];
    };
  };
}
