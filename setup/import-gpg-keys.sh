#!/bin/sh

dir="$1"
if [ -z "$1" ]; then
  dir="."
fi
echo "$dir"

for key in gipphe@gmail.com.key victor@strise.ai.pem; do
  gpg --import "$dir/$key"
done

# Trust all imported keys ultimately
gpg --list-keys --fingerprint --with-colons |
  sed -E -n -e 's/^fpr:::::::::([0-9A-F]+):$/\1:6:/p' |
  gpg --import-ownertrust
