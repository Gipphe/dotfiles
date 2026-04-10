{
  inputs,
  util,
  pkgs,
  ...
}:
util.mkToggledModule [ "hardware" "gpu" "nvidia" ] {
  name = "rtx3070";
  system-nixos = {
    imports = [ "${inputs.nixos-hardware}/common/gpu/nvidia/ampere" ];
    services.xserver.videoDrivers = [ "nvidia" ];
    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) vulkan-loader vulkan-validation-layers vulkan-tools;
    };
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
    };
    hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];
  };
}
