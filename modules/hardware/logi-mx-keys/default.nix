{
  util,
  lib,
  config,
  ...
}:
util.mkHardware {
  name = "logi-mx-keys";
  hm.config = lib.mkMerge [
    (
      let
        cfg = config.gipphe.programs.grimblast;
        grimblast = lib.getExe cfg.package;
      in
      lib.mkIf cfg.enable {
        gipphe.core.wm.binds = [
          # Logitech MX Keys screenshot hotkey sends SUPER_L+SHIFT_L+S
          {
            mod = [
              "SUPER_L"
              "SHIFT_L"
            ];
            key = "S";
            action.spawn = "${grimblast} copy area";
          }
          {
            mod = [
              "SUPER_L"
              "SHIFT_L"
              "ALT_L"
            ];
            key = "S";
            action.spawn = "${grimblast} copy screen";
          }
        ];
      }
    )
  ];
}
