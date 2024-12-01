{
  programs.nixvim.plugins.lsp.servers = {
    rls.enable = true;
    rust-analyzer = {
      enable = true;
      installCargo = false;
      installRustc = false;
      installRustfmt = false;
    };
  };
}
