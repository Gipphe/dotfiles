let
  nixos-vm-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxLKIK0m9fRx8HgC/zc/7tWO2f25MoeDsfSRP6wjlwI";
  nixos-vm-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHUbZTbdKdC0t5CMjSBv4/zZU2osa/Y+nLw3tLbBHrz";
  nixos-vm = [nixos-vm-host nixos-vm-user];
in {
  "nixos-vm-github.ssh.age".publicKeys = nixos-vm;
  "nixos-vm-github.ssh.pub.age".publicKeys = nixos-vm;
  "nixos-vm-gitlab.ssh.age".publicKeys = nixos-vm;
  "nixos-vm-gitlab.ssh.pub.age".publicKeys = nixos-vm;
  "nixos-vm-codeberg.ssh.age".publicKeys = nixos-vm;
  "nixos-vm-codeberg.ssh.pub.age".publicKeys = nixos-vm;
}
