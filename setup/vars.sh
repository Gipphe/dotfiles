#!/bin/sh

IS_NIXOS=$(if test -d "/etc/nixos"; then echo "yes"; else echo ""; fi)
IS_WSL=$(if test ! -z $(grep -E 'microsoft|WSL' /proc/sys/kernel/osrelease 2>/dev/null); then echo "yes"; else echo ""; fi)
IS_MAC=$(if test "$(uname)" = 'Darwin'; then echo "yes"; else echo ""; fi)
