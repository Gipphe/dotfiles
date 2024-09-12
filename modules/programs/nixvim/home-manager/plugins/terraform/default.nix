{
  programs.nixvim = {
    filetype.extension."tf" = "terraform";
    plugins = {
      lsp.servers.terraformls.enable = true;
      conform-nvim.settings.formatters_by_ft.terraform = [ "terraform_fmt" ];
    };
  };
}
