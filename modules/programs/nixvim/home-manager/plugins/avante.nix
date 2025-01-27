{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.gipphe.programs.nixvim.plugins.avante.enable = lib.mkEnableOption "avante plugin";
  config.programs = {
    nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        nui-nvim
        img-clip-nvim
        plenary-nvim
      ];
      extraConfigLua = ''
        require('img-clip').setup({
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        })
      '';
      plugins = {
        avante = {
          enable = true;
          settings = {
            provider = "copilot";
            auto_suggestions_provider = "copilot";
          };
        };
        copilot-lua.enable = true;
        dressing.enable = true;
        render-markdown = {
          enable = true;
          settings.file_types = [
            "markdown"
            "Avante"
          ];
        };
      };
    };
    fish.shellInit =
      lib.mkIf (config.programs.nixvim.plugins.avante.settings.provider == "claude") # fish
        ''
          set -gx ANTHROPIC_API_KEY "$(cat ${config.sops.secrets.anthropic_api_key.path})"
        '';
  };

  config.sops.secrets.anthropic_api_key = {
    sopsFile = ../../../../../secrets/claude-nvim-api-key.key;
    mode = "400";
    format = "binary";
  };
}
