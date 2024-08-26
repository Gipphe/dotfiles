let
  trond-arne-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdsV3fQUBWw5IoU2SBVYsPT8LzDqe5/Yv+WOpsIqoeA root@trond-arne";
  trond-arne-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiHCy+HvAtI0npM5rLZ+ZnCrfwLG06AO3sWuVjm7EgI gipphe@trond-arne";
  trond-arne = [
    trond-arne-host
    trond-arne-user
  ];

  VNB-MB-Pro-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvkGogV7sRBoR8XhCspJPNXpDPTAedNij+CoT/gqfNU victor@VNB-MB-Pro.local";
  VNB-MB-Pro = [ VNB-MB-Pro-user ];

  Jarle-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFAcsfSTqXBF7E5mIpAKGk6JDVg8cZEwxa+ysUUy+JJN root@Jarle";
  Jarle-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtYQ119Fz/wXHvgVcOeCsnECQYAhmrJ7Wzon1zBV1PZ gipphe@Jarle";
  Jarle = [
    Jarle-host
    Jarle-user
  ];

  services = [
    "github"
    "gitlab"
    "codeberg"
  ];
  hosts = {
    "trond-arne" = trond-arne;
    "VNB-MB-Pro" = VNB-MB-Pro;
    "Jarle" = Jarle;
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
  all = Jarle ++ VNB-MB-Pro ++ trond-arne;
in
entries // { "mods-cli-openai-api-key.age".publicKeys = all; }
