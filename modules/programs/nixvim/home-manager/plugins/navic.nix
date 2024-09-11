{
  programs.nixvim.plugins.navic = {
    enable = true;
    settings = {
      separator = " ";
      highlight = true;
      depth_limit = 5;
      lazy_update_context = true;
    };
  };
}
