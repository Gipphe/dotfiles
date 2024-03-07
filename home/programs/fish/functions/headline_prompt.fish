function __is_jj_repo
    test -d "$(pwd)/.jj"
    return $status
end

function __is_git_repo
    test -d "$(pwd)/.git"
    return $status
end

function __mk_git_flags_part
    set -l git_status $(git status --porcelain 2>/dev/null)
    if not test "$status" = 0
        return
    end
    set -l git_flag_ADDED
    set -l git_flag_MODIFIED
    set -l git_flag_STAGED
    for line in $git_status
        set -l index_status $(string sub -s 1 -e 1 $line)
        set -l worktree_status $(string sub -s 2 -e 2 $line)
        if test "$index_status" != "?"; and test "$index_status" != " "
            set git_flag_STAGED 1
            continue
        end

        switch $worktree_status
            case M
                set git_flag_MODIFIED 1
            case T
                set git_flag_MODIFIED 1
            case A
                set git_flag_ADDED 1
            case D
                set git_flag_MODIFIED 1
            case R
                set git_flag_MODIFIED 1
            case C
                set git_flag_MODIFIED 1
        end
    end

    set -l line
    if test -n "$git_flag_STAGED"
        set -a line '+'
    end
    if test -n "$git_flag_MODIFIED"
        set -a line '!'
    end
    if test -n "$git_flag_ADDED"
        set -a line '?'
    end

    echo -n -s $(string join '' $line)
end

function __mk_jj_flags_part
    set -l jj_status $(jj diff --summary)
    if not test "$status" = 0
        return
    end
    set -l statuses $(string sub -s 1 -e 1 $jj_status)
    set -l unique_statuses $(string join '\n' $statuses | string replace 'R' 'M' | string split '\n' | sort | uniq)
    set -l line
    for s in $unique_statuses
        switch $s
            case A
                set -a line '?'
            case M
                set -a line '!'
            case '*'
                echo $s >&2
                set -a line '#'
        end
    end
    echo -n -s $line
end

function __jj_prompt_part
    if set -l change_id $(NO_COLOR=true command jj log -r @ --template 'change_id.shortest()' --no-graph)
        echo $change_id
    end
end

function __mk_line_part
    set -l line_char _
    set -l color $argv[1]
    set -l strings $argv[2..]
    set -l part "$(string join '' $strings)"
    set -l part_len $(string length -V $part)
    set -l line_part $(string repeat -n $part_len $line_char)
    echo -n "$color$line_part$(set_color normal)"
end

function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -l color_user $(set_color red)
    set -l color_host $(set_color yellow)
    if set -q SSH_TTY
        set color_host $(set_color orange)
    end
    set -l color_status $(set_color brgreen)
    set -l color_error_status $(set_color brred)
    set -l color_misc $(set_color --dim white)
    set -l color_space $(set_color brblack)
    set -l color_pwd $(set_color blue)
    set -l color_vcs $(set_color brblue)
    set -l color_vcs_flags $(set_color magenta)
    set -l color_status $(set_color brgreen)
    set -l color_reset $(set_color normal)
    # set -l cwd_color (set_color $fish_color_cwd)
    # set -l vcs_color (set_color brpurple)
    set -l prompt_status ""

    # Since we display the prompt on a new line allow the directory names to be longer.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    # Color the prompt differently when we're root
    set -l suffix '❯'
    if functions -q fish_is_root_user; and fish_is_root_user
        # if set -q fish_color_cwd_root
        #     set cwd_color (set_color $fish_color_cwd_root)
        # end
        set suffix '#'
    end

    # Start of left prompt
    set -l left_line
    set -l left_part

    # Username
    set -l user_part $color_user $USER $color_reset
    set -a left_line $(__mk_line_part $color_user $user_part)
    set -a left_part $user_part

    # Username-hostname separator
    set -l at $color_misc ' @ ' $color_reset
    set -a left_line $(__mk_line_part $color_misc $at)
    set -a left_part $at

    # Hostname
    set -l host_part $color_host $(prompt_hostname) $color_reset
    set -a left_line $(__mk_line_part $color_host $host_part)
    set -a left_part $host_part

    # Colon after hostname
    set -l colon $color_misc ': ' $color_reset
    set -a left_line $(__mk_line_part $color_misc $colon)
    set -a left_part $colon

    # Current directory
    set -l pwd_part $color_pwd $(prompt_pwd) $color_reset
    set -a left_line $(__mk_line_part $color_pwd $pwd_part)
    set -a left_part $pwd_part

    # Start of right prompt
    set -l right_line
    set -l right_part

    # Color the prompt in red on error and show status
    set -l prompt_status
    if test $last_status -ne 0
        set color_status $color_error_status
        set prompt_status $color_status "[" $last_status "]" $color_reset
        set -a right_line $(__mk_line_part $color_status $prompt_status)
        set -a right_part $prompt_status

        set -a right_line $(__mk_line_part $color_misc ' ')
        set -a right_part "$color_misc $color_reset"
    end

    # VCS status
    set -l vcs_part
    if command -qs jj; and __is_jj_repo
        set vcs_part $color_vcs $(__jj_prompt_part) $color_reset
    else if command -qs git; and __is_git_repo
        set -g __fish_git_prompt_use_simple_chars true
        set -g __fish_git_prompt_show_informative_status true
        set vcs_part $color_vcs $(git_prompt_part '%s') $color_reset
    else
        set vcs_part $color_vcs $(fish_vcs_prompt) $color_reset
    end
    set -a right_line $(__mk_line_part $color_vcs $vcs_part)
    set -a right_part $vcs_part

    # Spacing between VCS status and VCS flags
    set -l spacing $color_misc ' ' $color_reset
    set -a right_line $(__mk_line_part $color_misc $spacing)
    set -a right_part $spacing

    # Opening bracket for VCS flags
    set -l open_flag $color_misc '[' $color_reset

    # VCS flags
    set -l vcs_flags_part
    if command -qs jj; and __is_jj_repo
        set vcs_flags_part $color_vcs_flags $(__mk_jj_flags_part) $color_reset
    else if command -qs jj; and __is_git_repo
        set vcs_flags_part $color_vcs_flags $(__mk_git_flags_part) $color_reset
    end
    # Closing bracket for VCS flags
    set -l close_flag $color_misc ']' $color_reset

    # Only attempt show VCS flags if set
    if test -n "$vcs_flags_part"; and test "$(string length -V $(string join '' $vcs_flags_part))" -gt 0
        set -a right_line $(__mk_line_part $color_misc $open_flag)
        set -a right_part $open_flag
        set -a right_line $(__mk_line_part $color_vcs_flags $vcs_flags_part)
        set -a right_part $vcs_flags_part
        set -a right_line $(__mk_line_part $color_misc $close_flag)
        set -a right_part $close_flag
    end

    # Join parts
    set left_part $(string join '' $left_part)
    set left_line $(string join '' $left_line)
    set right_part $(string join '' $right_part)
    set right_line $(string join '' $right_line)

    # Middle portion between left and right prompt based on length of each side
    set -l middle_line
    set -l middle_part
    set -l middle_len $(math "$COLUMNS - ($(string length -V $left_part) + $(string length -V $right_part))")
    if test "$middle_len" -gt 0
        set middle_part $color_space "$(string repeat -n $middle_len ' ')" $color_reset
        set middle_line $(__mk_line_part $color_space $middle_part)
    end

    set middle_part $(string join '' $middle_part)
    set middle_line $(string join '' $middle_line)

    set -l line "$left_line$middle_line$right_line"
    set -l prompt "$left_part$middle_part$right_part"

    echo -s $line
    echo -s $prompt
    echo -n -s $color_status $suffix ' ' $color_reset
end
