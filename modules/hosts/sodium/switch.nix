{ inputs, ... }: {
  # Applies sodium's configuration to the running Pi: builds on this machine,
  # copies the closure over SSH, and activates it there.
  #
  # Usage: nix run .#sodium-switch [switch|test|boot|dry-activate] [extra nixos-rebuild args...]
  #
  # `test` activates without making the new generation the boot default, so a
  # reboot undoes it. Use it for changes that could cut the Pi off the network.
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    lib.mkIf (system == "x86_64-linux") {
      apps.sodium = {
        type = "app";
        program = lib.getExe (
          inputs.flaketilities.lib.${system}.writeNushellApplication {
            name = "nh-sodium";
            runtimeInputs = builtins.attrValues {
              inherit (pkgs) nixos-rebuild openssh;
            };
            text = /* nu */ ''
              def main [
                  mode: string = "switch" # switch, test, boot or dry-activate
                  ...extra: string        # passed on to nixos-rebuild
              ]: nothing -> nothing {
                  let modes = [ "switch" "test" "boot" ]
                  if $mode not-in $modes {
                      error make { msg: $"Unknown mode '($mode)'. Use one of: ($modes | str join ', ')" }
                  }

                  ^nh os $mode --hostname "sodium" --target-host "gipphe@sodium.lan" --elevation-strategy auto -- ...$extra
                  if $env.LAST_EXIT_CODE != 0 {
                      exit $env.LAST_EXIT_CODE
                  }
              }
            '';
          }
        );
      };
    };
}
