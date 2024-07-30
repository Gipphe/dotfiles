function wizardcoder --argument-names prompt
    if not command -q wizardcoder.llamafile
        echo "wizardcoder.llamafile not in PATH" >&2
        exit 1
    end

    if test -z "$prompt"
        echo "Prompt parameter missing"
        return 1
    end
    set -l WIZARDCODER $(command -v wizardcoder.llamafile)
    set -l instructions "
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
$prompt

### Response:
"

    command $WIZARDCODER -p $instructions --silent-prompt 2>/dev/null
end
