{ util, pkgs, ... }:
util.mkToggledModule [ "hardware" "gpu" "nvidia" ] {
  name = "rtx3070";
  nixos = {
    services.xserver.videoDrivers = [ "nvidia" ];
    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # nvidia-vaapi-driver: the EGL backend is broken on driver >= 525,
      # so use the direct NVDEC backend instead.
      NVD_BACKEND = "direct";
      # Firefox/Zen sandbox the RDD process in a way that blocks
      # nvidia-vaapi-driver from reaching the GPU; this is the documented
      # workaround from the nvidia-vaapi-driver README.
      MOZ_DISABLE_RDD_SANDBOX = "1";
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
