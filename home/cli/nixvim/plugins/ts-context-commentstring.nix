{ ... }:
{
  plugins.nixvim.plugin.ts-context-commentstring = {
    enable = true;
    extraOptions = {
      enable_autocmd = false;
    };
  };
}
