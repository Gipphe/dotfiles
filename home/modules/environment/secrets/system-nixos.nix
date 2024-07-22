{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.gipphe.environment.secrets;
in
{
  imports = [ inputs.agenix.nixosModules.age ];
  config = lib.mkIf cfg.enable {
    # Necessary for agenix to use ssh host key
    services.openssh.enable = true;
  };
}
