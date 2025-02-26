let
  inherit (import ./mapping-prefixes.nix) session;
  k = x: "${session.prefix}${x}";
in
{
  programs.nvf.settings.vim = {
    session.nvim-session-manager = {
      enable = true;
      mappings = {
        deleteSession = k "d";
        loadLastSession = k "s";
        loadSession = k "l";
        saveCurrentSession = k "sc";
      };
    };
  };
}
