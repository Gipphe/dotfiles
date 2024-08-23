#!/bin/sh

if ! grep -q debian /etc/os-release; then
  echo "Not on debian. Exiting."
  exit 1
fi

is_wsl() {
  grep -qE 'microsoft|WSL' /proc/sys/kernel/osrelease 2>/dev/null
  return $?
}

if ! is_wsl; then
  echo "Not in WSL. Exiting."
  exit 1
fi

sudo apt update && sudo apt upgrade -y

# Enable systemd and other settings
sudo cp wsl.conf /etc/wsl.conf

# Check systemd user instance status
sudo service systemd-logind status

sudo apt install --reinstall -y dbus-user-session

echo "Please restart your WSL session to apply changes."
echo "# In Powershell:"
echo "wsl --shutdown"
