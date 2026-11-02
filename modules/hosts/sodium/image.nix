{ self, inputs, ... }:
{
  # Writes the SD card image for sodium and injects the age key that sops-nix
  # needs to decrypt every other secret on first boot.
  #
  # The key can't be delivered as a sops secret: it would only be decrypted at
  # activation, using the very key it's supposed to provide. Instead, the image
  # is built purely, and the key is copied from titanium's already-decrypted
  # secrets into a writable copy of the image. The key never enters the Nix
  # store.
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    lib.mkIf (system == "x86_64-linux") {
      apps.sodium-sd-image = {
        type = "app";
        program = lib.getExe (
          inputs.flaketilities.lib.${system}.writeNushellApplication {
            name = "sodium-sd-image";
            runtimeInputs = builtins.attrValues {
              inherit (pkgs)
                coreutils
                util-linux
                ;
            };
            text =
              let
                sodium = self.nixosConfigurations.sodium.config;
                username = "gipphe";
                user = sodium.users.users.${username};
                key = self.nixosConfigurations.titanium.config.sensitive.secrets.secrets."titanium/sodium-age-keys.txt";
              in
              /* nu */ ''
                # Runs an external command, raising an error on non-zero exit.
                def --wrapped exec-ok [cmd: string, ...args: string]: nothing -> string {
                    let r = (^$cmd ...$args | complete)
                    if $r.exit_code != 0 {
                        error make { msg: $"($cmd) failed: ($r.stderr | str trim)" }
                    }
                    $r.stdout
                }

                # Usage: sudo sodium-sd-image <output.img>
                def main [out: path]: nothing -> nothing {
                    let key = "${key}"
                    let home = "${user.home}"
                    let key_file = "${user.home}/.config/sops/age/keys.txt"
                    let owner = "${toString user.uid}:${toString sodium.users.groups.${user.group}.gid}"

                    if (exec-ok id -u | str trim) != "0" {
                        error make { msg: $"Must be run as root (needs to read ($key) and mount the image)" }
                    }

                    let src = (glob "${sodium.system.build.sdImage}/sd-image/*.img" | first)
                    exec-ok cp --reflink=auto --no-preserve=mode,ownership $src $out

                    let loopdev = (exec-ok losetup --find --show --partscan $out | str trim)
                    let mnt = (exec-ok mktemp -d | str trim)

                    let result = try {
                        # Partition 2 is the NIXOS_SD root filesystem.
                        exec-ok mount $"($loopdev)p2" $mnt

                        # Every directory from the home dir down to the key
                        # needs to be owned by the user, not root.
                        let parts = ($key_file | path relative-to $home | path dirname | path split)
                        let dirs = (
                            $parts
                            | enumerate
                            | each {|p| $parts | take ($p.index + 1) | path join }
                            | prepend ""
                            | each {|rel| $mnt | path join ($home | str trim --left --char "/") $rel }
                        )
                        for d in $dirs {
                            mkdir $d
                            exec-ok chown $owner $d
                            exec-ok chmod 0700 $d
                        }

                        let dest = ($mnt | path join ($key_file | str trim --left --char "/"))
                        exec-ok install -m 0600 $key $dest
                        exec-ok chown $owner $dest
                        exec-ok sync
                        { ok: true }
                    } catch {|e|
                        { ok: false, msg: $e.msg }
                    }

                    # Always clean up, even if the above failed.
                    try { exec-ok umount $mnt }
                    try { exec-ok losetup -d $loopdev }
                    try { rmdir $mnt }

                    if not $result.ok {
                        error make { msg: $result.msg }
                    }

                    print $"Wrote ($out) with key at ($key_file)"
                    print $"Flash with: sudo dd if=($out) of=/dev/sdX bs=4M conv=fsync status=progress"
                }
              '';
          }
        );
      };
    };
}
