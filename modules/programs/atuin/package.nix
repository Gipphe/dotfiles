# TODO Exists because fish 4.1.0 removed the "-k" flag from "bind", which atuin
# 18.8.0 still uses in its init script for fish. They have at this point in
# time fixed it on atuins side, but they have not yet released a new version.
# Drop this package and use nixpkgs version once the fix is released.
#
# Also, `buildRustPackage` overriding `cargoHash` is broken, so we have to copy
# the entire derivation in here.
# See https://github.com/NixOS/nixpkgs/issues/415397
{
  atuin,
}:
atuin.overrideAttrs {
  patches = [
    ./2902.patch
  ];
}
