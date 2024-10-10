{
  pkgs,
  config,
  ...
}:
let
  helpers = config.lib.nixvim;
in
{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "claude.vim";
        src = pkgs.fetchFromGitHub {
          owner = "pasky";
          repo = "claude.vim";
          rev = "883c1fcad735f5e9916fddea54e7068349cc5d59";
          hash = "sha256-FDv9qhP/RBjtsn2iHIH93jlZdphZKzoZiuJl1kbgjQs=";
        };
      })
    ];
    globals.claude_api_key = helpers.mkRaw ''
      (function ()
        local ok, res = pcall(function()
          local f = assert(io.open("${config.sops.secrets.claude_api_key.path}", "r"))
          local content = f:read("*all")
          f:close()
          return content
        end)

        if not ok then
          return ""
        end

        return res
      end)()
    '';
  };
  sops.secrets.claude_api_key = {
    sopsFile = ../../../../../secrets/claude-nvim-api-key.key;
    mode = "400";
    format = "binary";
  };
}
