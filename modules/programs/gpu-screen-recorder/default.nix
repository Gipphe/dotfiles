{ util, ... }:
util.mkProgram {
  name = "gpu-screen-recorder";
  nixos = {
    programs.gpu-screen-recorder = {
      enable = true;
      ui.enable = true;
    };
  };
}
