let
  inherit (import ./mapping-prefixes.nix) code;
in
{
  programs.nvf.settings.vim.lsp = {
    enable = true;
    formatOnSave = true;
    lightbulb.enable = true;
    lspSignature.enable = true;
    lspkind.enable = true;
    trouble.enable = true;
    mappings = {
      hover = "K";
      format = "${code.prefix}f";
    };
  };
}
