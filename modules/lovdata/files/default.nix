{
  config,
  util,
  pkgs,
  ...
}:
let
  lovdata-documents = "/app/lovdata-documents";
  dirs = [
    "/app/lovdata-import/ld/utf8-mor"
    "/app/lovdata-webdata"
    "/app/lovdata-static"
    "/app/lovdata-apidata"
  ];
in
util.mkToggledModule [ "lovdata" ] {
  name = "files";
  hm = {
    home.packages = [
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
      (pkgs.writeShellScriptBin "mount-lovdata" (
        let
          OPTIONS = "uid=$(id -u),gid=$(id -g),follow_symlinks,compression=no,reconnect";
          RO_OPTIONS = "${OPTIONS},ro";
        in
        ''
          sshfs -o "${RO_OPTIONS}" vnb@stage:/app/lovdata-import/ld/utf8-mor/ /app/lovdata-import/ld/utf8-mor/
          sshfs -o "${RO_OPTIONS}" vnb@stage:/app/lovdata-webdata /app/lovdata-webdata
          sshfs -o "${RO_OPTIONS}" vnb@stage:/app/lovdata-static /app/lovdata-static
          sshfs -o "${RO_OPTIONS}" vnb@stage:/app/lovdata-apidata /app/lovdata-apidata
          sshfs -o "${OPTIONS}" vnb@stage:/app/lovdata-documents /app/lovdata-documents
        ''
      ))
    ];

    systemd.user = {
      # mounts = readonly-mounts // lovdata-documents-mount;
      tmpfiles.rules = [
        "d /app 755 ${config.gipphe.username} ${config.gipphe.username} - -"
      ]
      ++ (builtins.map (dir: "d ${dir} 755 ${config.gipphe.username} ${config.gipphe.username} - -") (
        dirs ++ [ lovdata-documents ]
      ));
    };

    sops.secrets.lovdata-ssh-key = {
      format = "binary";
      sopsFile = ../../../secrets/utv-vnb-lt-lovdata-stage.ssh;
    };
  };

  system-nixos = {
    boot.kernelModules = [ "fuse" ];
    environment.etc."fuse.conf".text = ''
      user_allow_other
    '';
    environment.systemPackages = [ pkgs.sshfs ];
    users.users.${config.gipphe.username}.extraGroups = [ "fuse" ];
  };
}
