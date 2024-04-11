#!/usr/bin/env bash

declare -A services
services[github]="https://github.com/settings/ssh/new"
services[gitlab]="https://gitlab.com/-/profile/keys"
services[codeberg]="https://codeberg.org/user/settings/keys"

declare -A ssh_endpoints
ssh_endpoints[github]="git@github.com"
ssh_endpoints[gitlab]="git@gitlab.com"
ssh_endpoints[codeberg]="git@codeberg.org"

for key in "${!services[@]}"; do
	if [ -f "$HOME/.ssh/$key.ssh" ]; then
		echo "SSH key pair for $key already exists"
		continue
	fi

	echo "Generating SSH key pair for $key"
	ssh-keygen -N "" -t rsa -b 4096 -C "$key" -f "$HOME/.ssh/$key.ssh"
done

read -r -p "Open browser and navigate to the various services to input keys? (y/N): " confirm
[[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

opener=$(command -v open || command -v xdg-open || (test -n "$BROWSER" && echo "$BROWSER"))

for key in "${!services[@]}"; do
	url="${services[$key]}"
	if test -z "$url"; then
		echo "Missing URL for $key: $url"
		exit 1
	fi
	echo "Add the following key for ${key}:"
	echo ""
	pub_key=$(cat "$HOME/.ssh/$key.ssh.pub")
	echo "$pub_key"
	echo ""
	if command -v xclip &>/dev/null; then
		echo "$pub_key" | xclip -in -sel clip
		echo "URL copied to clipboard"
	elif command -v wl-copy &>/dev/null; then
		echo "$pub_key" | wl-copy
		echo "URL copied to clipboard"
	fi

	if test -z "$opener"; then
		echo "Unable to open the URL automatically. Navigate to the following URL manually in your browser:"
		echo ""
		echo "$url"
		echo ""
	else
		cmd="$opener '$url'"
		echo "Opening with $cmd"
		eval "$cmd"
	fi

	echo "Waiting for key to be added..."
	while true; do
		endpoint="${ssh_endpoints[$key]}"
		ssh -F /dev/null -i "$HOME/.ssh/${key}.ssh" -o IdentityAgent=none -T "$endpoint" &>/dev/null
		res="$?"
		if [[ "$res" == [01] ]]; then
			echo "Confirmed that SSH key has been added for ${key}"
			echo ""
			break
		fi
		sleep 5s
	done
done

echo "Done"
