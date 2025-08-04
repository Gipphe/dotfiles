{
  minecraftia,
  callPackage,
}:
callPackage ./ttf-to-psf.nix {
  name = "Minecraftia.ttf";
  pkg = minecraftia;
}
