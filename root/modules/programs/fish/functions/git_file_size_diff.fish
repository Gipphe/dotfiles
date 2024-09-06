function git_file_size_diff
    set -l USAGE "[--cached] [<rev-list-options>...]\n\nShow file size changes between two commits or the index and a commit."

    set -l SUBDIRECTORY_OK 1
    # bass -d . "$(git --exec-path)/git-sh-setup"
    set -l args $(git rev-parse --sq $argv)

    if test -z "$args"
        echo $USAGE
        exit 0
    end
    set -l cmd "diff-tree -r"
    if string match -rq -- --cached "$args"
        set cmd diff-index
    end

    eval "git $cmd $args" |
        begin
            set -l total 0

            while read A B C D M P
                set -l bytes

                switch $M
                    case M
                        set bytes $(math "$(git cat-file -s $D) - $(git cat-file -s $C)")
                    case A
                        set bytes "$(git cat-file -s $D)"
                    case D
                        set bytes "-$(git cat-file -s $C)"
                    case '*'
                        echo >&2 "warning: unhandled mode $M in \"$A $B $C $D $M $P\""
                        continue
                end
                set total $(math "$total + $bytes")
                printf '%d\t%s\n' $bytes "$P"
            end
            echo total $total
        end
end
