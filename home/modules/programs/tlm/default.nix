{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.tlm;
in
util.mkModule {
  options.gipphe.programs.tlm = {
    enable = lib.mkEnableOption "tlm";
    enableFishIntegration = lib.mkEnableOption "tlm fish integration" // {
      default = true;
    };
    ollamaHost = lib.mkOption {
      type = lib.types.str;
      description = "Ollama host URL";
      default = "http://localhost:11434";
      example = "http://ollama.example.com";
    };
  };
  hm = lib.mkIf cfg.enable {
    gipphe.programs.ollama.enable = true;
    home.packages = [ (pkgs.callPackage ./package.nix { }) ];
    home.file.".tlm".text = # yaml
      ''
        llm:
          host: "${cfg.ollamaHost}"
        shell: "auto"
      '';
  };
}
