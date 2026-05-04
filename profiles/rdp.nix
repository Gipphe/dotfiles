{ util, ... }:
{
  imports = [
    (util.mkToggledModule [ "profiles" "rdp" ] {
      name = "server";
      shared.gipphe.programs.rustdesk-client.enable = true;
    })
    (util.mkToggledModule [ "profiles" "rdp" ] {
      name = "client";
      shared.gipphe.programs.rustdesk-client.enable = true;
    })
  ];
}
