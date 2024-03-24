function wizardcoder
    if not command -q wizardcoder.llamafile
        echo "wizardcoder.llamafile not in PATH" >&2
        exit 1
    end

    if test -z "$1"
        echo "Prompt parameter missing"
        return 1
    end
    set -l WIZARDCODER $(command -v wizardcoder.llamafile)
    set -l prompt "
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
$1

### Response:
"

    command $WIZARDCODER -p $prompt --silent-prompt 2>/dev/null
end
