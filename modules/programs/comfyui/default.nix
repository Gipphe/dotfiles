{ util, ... }:
util.mkProgram {
  name = "comfyui";
  hm = {
    sops.secrets."cai-api-key.txt" = {
      format = "binary";
      sopsFile = ../../../secrets/pub-cai-api-key.txt;
    };
  };
}
