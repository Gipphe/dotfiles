{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.nix.enable {
    nix = {
      # Make builds run with low priority so my system stays responsive
      daemonCPUSchedPolicy = "idle";
      daemonIOSchedClass = "idle";
    };
  };
}
