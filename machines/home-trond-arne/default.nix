{ pkgs, filen, ... }: {
  meta = { name = "trond-arne"; };
  packages = with pkgs; [ xdg-utils _1password-gui filen ];
}
