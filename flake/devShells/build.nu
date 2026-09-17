#!/usr/bin/env nu

def main [command: string, --ask, ...rest: string] {
    if (which nixos-rebuild | length | $in > 0) {
        nh os $command ...$rest
        exit 0
    }

    if (which nix-on-droid | length | $in > 0) {
        let host = open env.json | get 'hostname'
        if $host == null or $host == "" {
            error make 'Found no hostname in env.json'
        }

        nix-on-droid build --flake $"(pwd)#($host)"

        print -e ""
        let nixOnDroidPkg = nix path-info --impure $"($env.NH_FLAKE)#nixOnDroidConfigurations.($host).activationPackage"
        nvd diff $nixOnDroidPkg result
        print -e ""

        let reply = if $ask {
            print -e 'Apply the config?'
            input --default 'n' --numchar 1 '[y/n]'
        } else {
            'y'
        }

        match ($reply | str lowercase) {
            'y' => {
                nix-on-droid switch --flake $"(pwd)#($host)"
            }
        }

        rm -f result
        exit 0
    }

    error make "This is not a NixOS or nix-on-droid system"
}
