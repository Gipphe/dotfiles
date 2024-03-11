{ pkgs, lib, ... }:
with builtins;
with lib.attrsets; {
  home.packages = with pkgs.fishPlugins; [ bass tide ];
  programs.fish = {
    enable = true;
    shellInit = readFile ./config.fish;
    functions = let
      function_files = filterAttrs (f: t: t == "regular") (readDir ./functions);
      function_list = attrNames function_files;
      functions =
        foldl' (fs: f: fs // { ${f} = readFile ./functions/${f}; }) { }
        function_list;
    in functions;
    plugins = with pkgs.fishPlugins; [
      {
        name = "tide";
        src = tide.src;
      }
      {
        name = "bass";
        src = bass.src;
      }
      # {
      #   name = "tide";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "IlanCosman";
      #     repo = "tide";
      #     rev = "refs/tags/v6";
      #     sha256 = lib.fakeHash;
      #   };
      # }
      # {
      #   name = "bass";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "edc";
      #     repo = "bass";
      #     rev = "master";
      #     sha256 = lib.fakeHash;
      #   };
      # }
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
