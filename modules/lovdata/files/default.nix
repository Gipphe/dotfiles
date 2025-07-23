{
  config,
  util,
  pkgs,
  ...
}:
util.mkToggledModule [ "lovdata" ] {
  name = "files";
  hm.home.packages = [
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
  system-nixos =
    let
      uid = builtins.toString config.users.users.${config.gipphe.username}.uid;
      gid = builtins.toString config.users.groups.${config.gipphe.username}.gid;
      lovdata-documents-options = "IdentityFile=${config.sops.secrets.lovdata-ssh-key.path},uid=${uid},gid=${gid},allow_other,default_permissions,reconnect,follow_symlinks,compression=no";
      lovdata-documents = "/app/lovdata-documents";
      options = "${lovdata-documents-options},ro";
      dirs = [
        "/app/lovdata-import/ld/utf8-mor"
        "/app/lovdata-webdata"
        "/app/lovdata-static"
        "/app/lovdata-apidata"
      ];
      base-mount = {
        type = "fuse.sshfs";
        inherit options;
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };
      readonly-mounts = builtins.map (
        dir:
        base-mount
        // {
          description = "Remote ${dir} mount";
          inherit options;
          what = "vnb@stage02.lovdata.c.bitbit.net:${dir}";
          where = dir;
        }
      ) dirs;
      lovdata-documents-mount = [
        (
          base-mount
          // {
            description = "Remote ${lovdata-documents} mount";
            options = lovdata-documents-options;
            what = "vnb@stage02.lovdata.c.bitbit.net:${lovdata-documents}";
            where = lovdata-documents;
          }
        )
      ];
    in
    {
      boot.kernelModules = [ "fuse" ];
      environment.etc."fuse.conf".text = ''
        user_allow_other
      '';
      environment.systemPackages = [ pkgs.sshfs ];
      sops.secrets.lovdata-ssh-key = {
        format = "binary";
        sopsFile = ../../../secrets/utv-vnb-lt-lovdata-stage.ssh;
      };
      systemd = {
        mounts = readonly-mounts ++ lovdata-documents-mount;
        tmpfiles.rules =
          [
            "d /app 755 ${config.gipphe.username} ${config.gipphe.username} - -"
          ]
          ++ (builtins.map (dir: "d ${dir} 755 ${config.gipphe.username} ${config.gipphe.username} - -") (
            dirs ++ [ lovdata-documents ]
          ));
      };
      users.users.${config.gipphe.username}.extraGroups = [ "fuse" ];
    };
}
