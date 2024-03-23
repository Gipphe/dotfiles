let
  nixos-vm-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMxLKIK0m9fRx8HgC/zc/7tWO2f25MoeDsfSRP6wjlwI";
  nixos-vm-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHUbZTbdKdC0t5CMjSBv4/zZU2osa/Y+nLw3tLbBHrz";
  nixos-vm = [
    nixos-vm-host
    nixos-vm-user
  ];

  trond-arne-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdsV3fQUBWw5IoU2SBVYsPT8LzDqe5/Yv+WOpsIqoeA root@trond-arne";
  trond-arne-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiHCy+HvAtI0npM5rLZ+ZnCrfwLG06AO3sWuVjm7EgI gipphe@trond-arne";
  trond-arne = [
    trond-arne-host
    trond-arne-user
  ];

  services = [
    "github"
    "gitlab"
    "codeberg"
  ];
  hosts = {
    "nixos-vm" = nixos-vm;
    "trond-arne" = trond-arne;
  };
  extensions = [
    ".ssh"
    ".ssh.pub"
  ];
  inherit (builtins)
    foldl'
    map
    mapAttrs
    attrValues
    ;
  subsequences =
    xs: ys: foldl' (acc: curr: acc ++ (foldl' (acc': curr': acc' ++ [ (curr + curr') ]) [ ] ys)) [ ] xs;
  keyNames = subsequences services extensions;
  hostKeys = mapAttrs (host: keys: {
    inherit keys;
    keyNames = map (k: "${host}-${k}.age") keyNames;
  }) hosts;
  entries = foldl' (
    acc: curr:
    acc // (foldl' (acc': curr': acc' // { "${curr'}".publicKeys = curr.keys; }) { } curr.keyNames)
  ) { } (attrValues hostKeys);
in
entries
# {
#   "nixos-vm-github.ssh.age".publicKeys = nixos-vm;
#   "nixos-vm-github.ssh.pub.age".publicKeys = nixos-vm;
#   "nixos-vm-gitlab.ssh.age".publicKeys = nixos-vm;
#   "nixos-vm-gitlab.ssh.pub.age".publicKeys = nixos-vm;
#   "nixos-vm-codeberg.ssh.age".publicKeys = nixos-vm;
#   "nixos-vm-codeberg.ssh.pub.age".publicKeys = nixos-vm;
# }
