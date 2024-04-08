#!/usr/bin/env bash

set -e

for f in bashrc bash.bashrc zshrc; do
  if [ -f "/etc/$f.before-nix-darwin" ]; then
    sudo mv "/etc/$f.before-nix-darwin" "/etc/$f"
  fi

  if [ -f "/etc/$f.backup-before-nix" ]; then
    sudo mv "/etc/$f.backup-before-nix" "/etc/$f"
  fi
done

for s in org.nixos.nix-daemon.plist org.nixos.darwin-store.plist; do
  p="/Library/LaunchDaemons/$s"
  sudo launchctl unload "$p"
  sudo rm -f "$p"
done

sudo dscl . -delete /Groups/nixbld
for u in $(sudo dscl . -list /Users | grep _nixbld); do
  sudo dscl . -delete "/Users/$u"
done

echo "sudo vifs and remove the /nix line"
echo "Remove 'nix' line from /etc/synthetic.conf"
read -r -p "Press enter to continue"

sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels
sudo diskutil apfs deleteVOlume /nix
r=$?
if [ "$r" != "0" ]; then
  echo "Failed to delete nix store. Try diskutil list to see if you can remove it manually. Might have to reboot before removing."
  exit $r
fi
