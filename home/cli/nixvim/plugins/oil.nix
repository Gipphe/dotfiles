{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings = {
        viewOptions = {
          show_hidden = true;
          is_always_hidden = ''
            function(name)
              return name == ".git" or name == ".jj"
            end
          '';
        };
      };
    };
    keymaps = [ ];
    extraPlugins = [ pkgs.vimPlugins.nvim-web-devicons ];
  };
}
