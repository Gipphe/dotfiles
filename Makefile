SHELL = bash
SHELL_CONFIG = $(HOME)/.zshrc
.SHELLFLAGS = -ec -o pipefail

NULL =
SPACE = $(NULL) $(NULL)
define NEWLINE


endef

.DEFAULT_GOAL = setup

STAMP = .stamp

_IS_WSL = $(shell if [ ! -z $$(grep -E 'microsoft|WSL' /proc/sys/kernel/osrelease 2>/dev/null) ]; then echo "1"; else echo ""; fi)
ifneq ($(_IS_WSL),)
IS_WSL = yes
endif

_IS_MAC = $(shell if [ "$$(uname)" = 'Darwin' ]; then echo "yes"; else echo ""; fi)
ifneq ($(_IS_MAC),)
IS_MAC = yes
endif

TARGETS =
ifdef IS_MAC
TARGETS += mac
endif

.PHONY: setup
setup: $(TARGETS)

.PHONY: mac
mac: $(HOME)/.config/nix-darwin/flake.nix

$(HOME)/.config/nix-darwin/flake.nix: darwin/flake.nix | $(STAMP)/install-nix-mac
	mkdir -p $(@D)
	cp $< $@
	sed -i '' "s/<replace-me>/$$(scutil --get LocalHostName)/" $@

$(STAMP)/install-nix-mac: | $(STAMP)/
	curl -L https://nixos.org/nix/install | sh
	touch $@

$(STAMP)/install-nix-wsl: | $(STAMP)/
	curl -L https://nixos.org/nix/install | sh -s -- --daemon
	touch $@

$(STAMP)/install-nix-linux: | $(STAMP)/install-nix-wsl
	touch $@

$(STAMP)/:
	mkdir -p $@
