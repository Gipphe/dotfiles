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
              set -l file (fd --type file '.' /app/config | fzf)
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
    boot.kernelModules = [ "fuse" ];
    environment.etc."fuse.conf".text = ''
      user_allow_other
    '';
    sops.secrets.lovdata-ssh-key = {
      format = "binary";
      sopsFile = ../../../secrets/utv-vnb-lt-lovdata-stage.ssh;
    };
    systemd = {
      mounts = [
        {
          type = "fuse.sshfs";
          what = "vnb@stage:/app/lovdata-import/ld/utf8-mor";
          where = "/app/lovdata-import/ld/utf8-mor";
          options = "IdentityFile=${config.sops.secrets.lovdata-ssh-key.path},allow_other,default_permissions,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,StrictHostKeyChecking=no";
          after = [ "network-online.target" ];
        }
      ];
      tmpfiles.rules = [
        "d /app 755 ${config.gipphe.username} ${config.gipphe.username} - -"
        "d /app/lovdata-import/ld/utf8-mor 755 ${config.gipphe.username} ${config.gipphe.username} - -"
      ];
    };
    users.${config.gipphe.username}.extraGroups = [ "fuse" ];
  };
}
