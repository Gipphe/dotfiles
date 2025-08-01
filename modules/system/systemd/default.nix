{ util, ... }:
util.mkToggledModule [ "system" ] {
  name = "systemd";
  system-nixos = {
    systemd = {
      # Systemd OOMd
      # Fedora enables these options by deafult. See the 10-oomd-* files here:
      # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
      oomd.enableRootSlice = true;
    };
  };
}
