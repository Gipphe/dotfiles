{ util, ... }:
util.mkToggledModule [ "networking" ] {
  name = "lovdata-dns";
  system-nixos = {
    networking.search = [
      "lovdata.no"
      "lovdata.c.bitbit.net"
    ];
  };
}
