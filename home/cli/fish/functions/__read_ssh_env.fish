function __read_ssh_env
    set -l SSH_ENV $argv[1]
    set -l lines $(cat $SSH_ENV | string split '\n')
    for line in $lines
        if string match -qr '^#'
            continue
        end
        set -l assignment (
          echo $line |
            string split -f1 ';' |
            string split '='
        )
        if test "$(count $assignment)" -lt 2
            continue
        end
        set -l key $assignment[1]
        set -l value $assignment[2]
        eval "set -gx $key $value"
    end
end
