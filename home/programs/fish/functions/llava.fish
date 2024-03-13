#!/usr/bin/env fish

function llava
    if not command -q llava.llamafile
        echo "llava.llamafile not in PATH" >&2
        exit 1
    end

    if test -z "$argv[1]"
        echo "Image path parameter missing"
        return 1
    end
    if test -z "$argv[2]"
        echo "Prompt parameter missing"
        return 1
    end
    set -l LLAVA $(command -v llava.llamafile)
    set -l prompt "
### User: $argv[2]
### Assistant:
"
    command $LLAVA --image $argv[1] -p $prompt --silent-prompt 2>/dev/null
end
