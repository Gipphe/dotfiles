{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkProgram {
  name = "openconnect";
  hm = {
    home.packages = with pkgs; [
      openconnect
      networkmanager-openconnect
      openconnect_gnutls
      inputs.openconnect-sso.packages.${pkgs.system}.openconnect-sso
    ];
    programs.fish.shellAbbrs.vpn = "op item get Lovdata --fields label=password --reveal | openconnect --passwd-on-stdin --user 'vnb@lovdata.no' --protocol anyconnect lovdataazure.ivpn.se";
  };
}
