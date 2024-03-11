#!/bin/sh

if command -v nix; then
	echo "Nix already installed"
fi

function install_nix {}
	IS_WSL=$(if [ ! -z $(grep -E 'microsoft|WSL' /proc/sys/kernel/osrelease 2>/dev/null) ]; then echo "1"; else echo ""; fi)
	IS_MAC=$(if [ "$(uname)" = 'Darwin' ]; then echo "yes"; else echo ""; fi)

	# $(HOME)/.config/nix-darwin/flake.nix: darwin/flake.nix | $(STAMP)/install-nix-mac
	# 	mkdir -p $(@D)
	# 	cp $< $@
	# 	sed -i '' "s/<replace-me>/$$(scutil --get LocalHostName)/" $@

	if [ -f "$IS_MAC" ]; then
	fi
$(STAMP)/install-nix-mac: | $(STAMP)/
	curl -L https://nixos.org/nix/install | sh
	touch $@

$(STAMP)/install-nix-wsl: | $(STAMP)/
	curl -L https://nixos.org/nix/install | sh -s -- --daemon
	touch $@

$(STAMP)/install-nix-linux: | $(STAMP)/install-nix-wsl
	touch $@


}
