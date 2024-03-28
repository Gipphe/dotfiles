{ ... }:
{
  imports =
    let
      inherit (builtins) readDir filter attrNames;
      files = filter (n: n != "default.nix") (attrNames (readDir ./.));
    in
    files;
  plugins = {
    mini.enable = true;
    copilot-lua.enable = true;
  };
}
