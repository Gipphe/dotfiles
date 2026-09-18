{ util, inputs, ... }:
util.mkToggledModule [ "gaming" ] {
  name = "wine";
  nixos = {
    imports = [ inputs.nix-gaming.nixosModules.wine ];
    programs.wine = {
      enable = true;
      binfmt = true;
      ntsync = true;
    };
  };
}
