if test -z "$PINENTRY_PROGRAM"
    set -x PINENTRY_PROGRAM pinentry-rofi
end

function prompt-password
    set pinentry ($PINENTRY_PROGRAM)
    set -l response (begin
    echo "SETTITLE 1password"
    echo "SETPROMPT Master password:"
    echo "SETDESC Enter your 1password master password."
    echo "GETPIN"
    echo "BYE"
  end | $PINENTRY_PROGRAM)

    for line in $response
        switch (string sub -s 1 -l 2 $line)
            case "D "
                set password (string sub -s 3 $line)
            case OK
            case ERR
                echo "Error from pinentry: $line" >&2
                exit 1
        end
    end
end

function login
    if command -q $PINENTRY_PROGRAM
        set password (prompt-password)
        echo $password | op signin >$HOME/.op/session
    end
end

function print-account-list
    op whoami &>/dev/null
    set logged_in $status
    if test $logged_in -ne 0
        login
    end

    op items list --format=json | jq -r '.[] | " - \(.title) (\(.additional_information)) [\(.id)]"' | sort
end

function show-account-options
    set -l id $argv[1]
    set -l entry $(op get item "$id" --format=json)

    echo ">> Copy password [$id]"
    echo ">> Copy username [$id]"

    if test -n "$(echo $entry | jq -r '.fields | select(.type == "OTP" and .value != null and (.value | contains("otpauth://")))')"
        echo ">> Copy OTP [$id]"
    end

    set -l url (get-url $entry)
    if test $status = 0 && is-actual-url "$url"
        echo ">> Open $url [$id]"
        echo ">> Copy URL [$id]"
    end

    echo ">> Copy ID [$id]"
end

function get-url
    set -l entry $argv[1]
    echo $entry | jq '.urls | map(select(.primary)) | .[0].href' 2>/dev/null
end

function open-account-url
    set -l url (get-url (op item get $argv[1] --format json))
    if test -n "$url"
        xdg-open "$url" &>/dev/null
    else
        exit 2
    end
end

function is-actual-url
    set -l url $argv[1]
    test -n "$url" && string match -qr "^https?://"
    return $status
end

function is-entry-selected
    test -n "$argv"
    return $status
end

function id-in-selection
    echo $argv[1] | grep -oE '\[[a-z0-9]+\]$' | tr -d '[]'
end

if test ! -f "$HOME/.op/session"
    login
end
source "$HOME/.op/session"

if is-entry-selected $argv[1]
    set -l selected $argv[1]
    set -l id "$(id-in-selection "$selected")"

    if test -n "$id"
        switch $selected
            case '>> Copy password*'
                op item get "$id" --fields label=password --reveal | wl-copy -n
            case '>> Copy username*'
                op item get "$id" --fields label=username | wl-copy -n
            case '>> Copy OTP*'
                op item get "$id" --otp | wl-copy -n
            case '>> Copy URL*'
                get-url (op item get "$id" --format=json) | wl-copy -n
            case '>> Copy ID*'
                echo "$id" | wl-copy -n
            case '>> Open*'
                open-account-url "$id"
            case '*'
                show-account-options "$id"
        end
    else
        echo "Could not detect the entry ID of \"$selection\""
        exit 1
    end
else
    print-account-list
end
