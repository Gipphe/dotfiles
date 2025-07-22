{
  util,
  pkgs,
  config,
  ...
}:
util.mkProgram {
  name = "maven";
  hm = {
    home = {
      packages = [
        pkgs.maven
        (util.writeFishApplication {
          name = "lovdata-config";
          runtimeInputs = with pkgs; [
            coreutils
            fd
            fzf
          ];
          text = # fish
            ''
              set -l file (fd --type file '.' /app | fzf)
              or exit 1

              set -l dest /app/lovdata-config.xml

              if test -e $dest && ! test -L $dest
                echo "$dest is not a symbolic link!" >&2
                exit 2
              end
              rm -f $dest
              ln -s $file $dest
              echo "Linked $dest to $file" >&2
            '';
        })
      ];
      file.".m2/settings-security.xml".text = ''
        <settingsSecurity>
          <relocation>
            ${config.sops.secrets.lovdata-maven-settings-security.path}
          </relocation>
        </settingsSecurity>
      '';
    };
    sops.secrets.lovdata-maven-settings-security = {
      format = "binary";
      sopsFile = ../../../secrets/utv-vnb-lt-maven-settings-security.xml;
    };
  };
  system-nixos = {
    systemd.tmpfiles.rules = [
      "d /app 755 ${config.gipphe.username} ${config.gipphe.username} - -"
    ];
  };
}
