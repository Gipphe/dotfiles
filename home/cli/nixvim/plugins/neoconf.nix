{ lib, config, pkgs, ... }:
let cfg = config.gipphe.nixvim.neoconf;
in
{
  options.gipphe.nixvim.neoconf = {
    enable = lib.mkEnableOption "neoconf";
  };
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.neoconf-nvim ];
      extraConfigLua = "require('neoconf').setup()";
    };
  };
}
