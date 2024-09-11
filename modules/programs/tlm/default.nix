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
util.mkProgram {
  name = "tlm";
  options.gipphe.programs.tlm = {
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
  hm = {
    gipphe.programs.ollama.enable = lib.mkForce true;
    home.packages = [ (pkgs.callPackage ./package.nix { }) ];
    home.file.".tlm".text = # yaml
      ''
        llm:
          host: "${cfg.ollamaHost}"
        shell: "auto"
      '';
  };
}
