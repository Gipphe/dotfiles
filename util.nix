{
  lib,
  gnused,
  writeShellApplication,
  ...
}:
let
  inherit (builtins)
    attrNames
    hasAttr
    map
    readDir
    ;
  inherit (lib) flatten;
  inherit (lib.attrsets) foldlAttrs filterAttrs;

  mkCopyActivationScript =
    {
      name,
      fromDir,
      toDir,
    }:
    writeShellApplication {
      inherit name;
      text = ''
        rm -rf "${toDir}"
        cp -rL "${fromDir}" "${toDir}"
      '';
    };

  copyFileFixingPaths =
    name: from: to:
    writeShellApplication {
      inherit name;
      runtimeInputs = [ gnused ];
      runtimeEnv = {
        inherit to from;
      };
      text = ''
        toDir="$(dirname -- $to)"
        mkdir -p "$toDir"
        rm -f "$to"
        sed -r 's!/nix/store/.*/bin/(\S+)!\1!' "$from" \
        | tee "$to" >/dev/null
      '';
    };

  setCaskHash =
    cask: hash:
    cask.overrideAttrs (_: {
      src = cask.src.overrideAttrs { outputHash = hash; };
    });

  # Traverse down each subdirectory starting from `dir`, stopping at the first
  # `default.nix` found for each subdirectory.
  #
  # Example:
  #
  # Given a file system like so:
  #
  # foo/
  #   bar/
  #     default.nix
  #   baz/
  #     quack/
  #       default.nix
  #   quux/
  #     default.nix
  #     one/
  #       default.nix
  #     two/
  #       default.nix
  #
  # `recurseFirstMatching ./foo` will return the following list:
  #
  # [
  #   ./foo/bar/default.nix
  #   ./foo/baz/quack/default.nix
  #   ./foo/quux/default.nix
  # ]
  #
  # Notice the omission of `./foo/quux/one/default.nix` and
  # `./foo/quux/two/default.nix`. Since we found a `default.nix` in
  # `./foo/quux`, we do not traverse further down that part of the file tree.
  recurseFirstMatching =
    file: dir:
    lib.pipe dir [
      readDir
      (filterAttrs (_: type: type == "directory"))
      attrNames
      (map (d: /.${dir}/${d}))
      (map (recurseFirstMatchingIncludingSibling file))
      flatten
    ];
  recurseFirstMatchingIncludingSibling =
    file: dir:
    let
      items = readDir dir;
    in
    if hasAttr file items && items.${file} == "regular" then
      [ /.${dir}/${file} ]
    else
      foldlAttrs (
        acc: name: type:
        if type == "directory" then
          acc ++ recurseFirstMatchingIncludingSibling file /.${dir}/${name}
        else
          acc
      ) [ ] items;

  # Returns a module that merely consists of the package specified, using the
  # passed name as the name for the module and the module options.
  mkSimpleProgram =
    name: package:
    {
      lib,
      config,
      flags,
      ...
    }:
    {
      options.gipphe.programs.${name}.enable = lib.mkEnableOption name;
    }
    // (lib.optionalAttrs flags.isHm {
      config = lib.mkIf config.gipphe.programs.${name}.enable { home.packages = [ package ]; };
    });

  # Version of `mkSimpleProgrma` that uses the passed name to fetch the package
  # from `pkgs`.
  mkSimpleProgramByName = name: { pkgs, ... }@args: mkSimpleProgram name pkgs.${name} args;

  mkProfileSet =
    name: cfg:
    { lib, config, ... }:
    {
      options.gipphe.profiles.${name}.enable = lib.mkEnableOption "${name} profile";
      config = lib.mkIf config.gipphe.profiles.${name}.enable cfg;
    };
  mkProfile = name: cfg: { imports = [ (mkProfileSet name cfg) ]; };

  mkProgram =
    {
      name,
      options ? { },
      hm ? { },
      system-nixos ? { },
      system-darwin ? { },
      system-all ? { },
      shared ? { },
    }:
    {
      imports = [
        (
          { lib, config, ... }:
          let
            optPath = [
              "gipphe"
              "programs"
            ] ++ (lib.splitString "." name) ++ [ "enable" ];
            isEnabled = lib.attrByPath optPath false config;
          in
          mkModule {
            options = options // lib.setAttrByPath optPath (lib.mkEnableOption name);
            hm = lib.mkIf isEnabled hm;
            system-nixos = lib.mkIf isEnabled system-nixos;
            system-darwin = lib.mkIf isEnabled system-darwin;
            system-all = lib.mkIf isEnabled system-all;
            shared = lib.mkIf isEnabled shared;
          }
        )
      ];
    };
  mkModule =
    {
      options ? { },
      hm ? { },
      system-nixos ? { },
      system-darwin ? { },
      system-all ? { },
      shared ? { },
    }:
    {
      imports = [
        (
          { lib, flags, ... }:
          {
            imports =
              [
                { inherit options; }
                shared
              ]
              ++ lib.optional flags.isHm hm
              ++ lib.optional flags.isNixos system-nixos
              ++ lib.optional flags.isNixDarwin system-darwin
              ++ lib.optional flags.isSystem system-all;
          }
        )
      ];
    };
in
{
  inherit
    copyFileFixingPaths
    mkCopyActivationScript
    mkModule
    mkProfile
    mkProfileSet
    mkProgram
    mkSimpleProgram
    mkSimpleProgramByName
    recurseFirstMatching
    recurseFirstMatchingIncludingSibling
    setCaskHash
    ;
}
