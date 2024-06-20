{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      # Utils
      dconf

      # Misc
      neofetch
    ]
    ++ (if pkgs.stdenv.isDarwin then [ ] else [ libgcc ]);
}
