{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.tide;
in
{
  options.gipphe.programs.tide = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf (config.programs.fish.enable && cfg.enable) {
    programs.fish = {
      shellAbbrs = {
        set_tide_prompt = "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Solid --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=Yes";
      };
      plugins = [
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "57afe578d36110615df6c8ce9165d9971e271063";
            sha256 = "sha256-dw6XLjtaOF7jVAsMqH+CZJFpy20o3gc85A8CQWe/N/8=";
          };
        }
      ];
    };
  };
}
