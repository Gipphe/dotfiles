{ util, ... }:
{
  imports = [
    (util.mkToggledModule [ "profiles" "rdp" ] {
      name = "server";
      shared.gipphe.programs.sunshine.enable = true;
      hm.services.sunshine.autoStart = true;
    })
    (util.mkToggledModule [ "profiles" "rdp" ] {
      name = "client";
      shared.gipphe.programs.moonlight-qt.enable = true;
    })
  ];
}
