use upload-cache.nu

export def --wrapped main [--ask, ...rest]: nothing -> nothing {
    let host = open env.json | get 'hostname'
    if $host == null or $host == "" {
        error make 'Found no hostname in env.json'
    }

    nix-on-droid build --flake $"(pwd)#($host)"
    let out_link = './result' | path expand

    let nixOnDroidPkg = nix path-info --impure $"($env.NH_FLAKE)#nixOnDroidConfigurations.($host).activationPackage"
    nvd diff $nixOnDroidPkg result | $"\n($in)\n" | print -e

    let reply = if $ask {
        print -e 'Apply the config?'
        input --default 'n' --numchar 1 '[y/n]'
    } else {
        'y'
    }

    match ($reply | str lowercase) {
        'y' => {
            upload-cache $out_link
            nix-on-droid switch --flake $"(pwd)#($host)"
        }
    }

    rm -f result
}
