{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs, ags, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # additional libraries and packages to add to gjs' runtime
      extraPackages = [
        # ags.packages.${system}.battery
        # pkgs.fzf
      ];
    in
    {
      packages.${system}.default = ags.lib.bundle {
        inherit pkgs;
        src = ./.;
        name = "giphtshell";
        entry = "app.ts";
        gtk4 = false;
        inherit extraPackages;
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          (ags.packages.${system}.default.override {
            inherit extraPackages;
          })
        ];
      };
    };
}
