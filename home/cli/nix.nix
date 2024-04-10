{
  programs.fish.shellAbbrs = {
    # Taken from https://discourse.nixos.org/t/list-and-delete-nixos-generations/29637/6
    prune-gens = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/sytem --older-than";
  };
}
