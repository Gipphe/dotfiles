{ util, inputs, ... }:
util.mkGaming {
  name = "mangohud";
  nixos = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "mangohud";
        value = ./wrapper.nix;
      })
    ];
    wrappers.mangohud = {
      enable = true;
      settings = ''
        legacy_layout=0
        no_display # hide the HUD by default
        font_size=32
        hud_compact
        fps_limit=0,60,120,240
        toggle_fps_limit=Shift_L+F1
        toggle_logging=Shift_L+F2
        reload_cfg=Shift_L+F4
        toggle_preset=Shift_L+F10
        toggle_hud_position=Shift_L+F11
        toggle_hud=Shift_L+F12

        cpu_load_change
        cpu_mhz
        cpu_power
        cpu_stats
        cpu_temp

        ram

        gpu_core_clock
        gpu_fan
        gpu_junction_temp
        gpu_load_change
        gpu_mem_clock
        gpu_mem_temp
        gpu_power
        gpu_stats
        gpu_temp
        gpu_voltage

        vram

        battery
        battery_watt

        io_read
        io_write

        fsr
        gamemode
        resolution
        refresh_rate
        vulkan_driver
        histogram

        show_fps_limit
        fps
        frame_timing
        frametime  
      '';
    };
  };
}
