{ pkgs, lib, config, ... }:
with builtins;
with lib.attrsets; {
  home.packages = with pkgs.fishPlugins; [ bass tide ];
  programs.fish = {
    enable = true;
    shellInit = readFile ./config.fish;
    functions = let
      function_files = filterAttrs (f: t: t == "regular") (readDir ./functions);
      function_list = attrNames function_files;
      functions = foldl' (fs: f:
        let fname = head (split "\\.fish$" f);
        in fs // { ${fname} = readFile ./functions/${f}; }) { } function_list;
    in functions;
    shellAbbrs = {
      hms =
        "home-manager switch --flake ${config.home.homeDirectory}/projects/dotfiles";
    };
    plugins = with pkgs; [
      # {
      #   name = "tide";
      #   src = fishPlugins.tide.src;
      # }
      # tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Solid --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
      {
        name = "bass";
        src = fishPlugins.bass.src;
      }
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "57afe578d36110615df6c8ce9165d9971e271063";
          sha256 = "sha256-dw6XLjtaOF7jVAsMqH+CZJFpy20o3gc85A8CQWe/N/8=";
        };
      }
      {
        name = "nix";
        src = pkgs.fetchFromGitHub {
          owner = "kidonng";
          repo = "nix.fish";
          rev = "master";
          sha256 = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
        };
      }
    ];
  };
}
