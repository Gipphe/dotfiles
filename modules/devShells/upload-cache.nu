export def main [out_link: string]: nothing -> nothing {
    let unit = 'dotfiles-cachix-upload'
    let nu_path = which nu | get path | first
    const dir = path self | path expand
    ^systemctl stop --user $unit | complete
    ^systemctl reset-failed --user $unit | complete
    ^systemd-run --user --same-dir $"--unit=($unit)" $nu_path $"($dir)/upload-cache-job.nu" $unit $out_link
}
