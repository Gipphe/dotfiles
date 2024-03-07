{ pkgs, ... }: {
  meta = { name = "jarle"; };
  packages = with pkgs; [ xdg-utils ];
}
