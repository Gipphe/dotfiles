{ config, pkgs, ... }:
{
  programs.nixvim.plugins.lsp.servers = {
    nixd = {
      enable = true;
      extraOptions = {
        nixpkgs = {
          expr = "import <nixpkgs> { }";
        };
        formatting = {
          command = [ "nixfmt" ];
        };
        options = {
          nixos = {
            expr =
              let
                configType = if pkgs.stdenv.isDarwin then "darwinConfigurations" else "nixosConfigurations";
              in
              "(builtins.getFlake \"${config.home.sessionVariables.FLAKE}\").${configType}.${config.gipphe.hostName}.options";
          };
        };
      };
    };
  };
}
