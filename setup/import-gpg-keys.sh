#!/bin/sh

dir="$1"
if [ -z "$1" ]; then
  dir="."
fi
echo "$dir"

gpg --import "$dir/gipphe@gmail.com.key"

# Trust all imported keys ultimately
gpg --list-keys --fingerprint --with-colons |
  sed -E -n -e 's/^fpr:::::::::([0-9A-F]+):$/\1:6:/p' |
  gpg --import-ownertrust
