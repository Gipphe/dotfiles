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
    isAttrs
    isList
    listToAttrs
    map
    readDir
    ;
  inherit (lib) flatten;
  inherit (lib.attrsets) foldlAttrs filterAttrs;

  recursiveMap =
    f: x:
    let
      recurseAttrs =
        set:
        listToAttrs (
          map (k: {
            name = k;
            value = recursiveMap f set.${k};
          }) (attrNames set)
        );
      recurseList = list: map (recursiveMap f) list;
    in
    if isList x then
      recurseList x
    else if isAttrs x then
      recurseAttrs x
    else
      f x;

  importSiblings =
    let
      go =
        acc: fileName: _:
        acc ++ (if fileName != "default.nix" then [ fileName ] else [ ]);
    in
    dir:
    lib.pipe dir [
      readDir
      (lib.attrsets.foldlAttrs go [ ])
      (map (f: /.${dir}/${f}))
    ];

  mkCopyActivationScript =
    name: fromDir: toDir:
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
    cask.overrideAttrs (c: {
      src = cask.src.overrideAttrs { outputHash = hash; };
    });

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

  mkSimpleProgramByName = name: { pkgs, ... }@args: mkSimpleProgram name pkgs.${name} args;
  mkSimpleProgramImports = name: [ (mkSimpleProgramByName name) ];
  mkSimpleProgramModule = name: { imports = mkSimpleProgramImports name; };
  mkHmProgramModule = name: {
    imports = [
      (
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
          config = lib.mkIf config.gipphe.programs.${name}.enable { programs.${name}.enable = true; };
        })
      )
    ];
  };

  mkProfileSet =
    name: cfg:
    { lib, config, ... }:
    {
      options.gipphe.profiles.${name}.enable = lib.mkEnableOption "${name} profile";
      config = lib.mkIf config.gipphe.profiles.${name}.enable cfg;
    };
  mkProfile = name: cfg: { imports = [ (mkProfileSet name cfg) ]; };

  smartImport =
    path:
    { lib, flags, ... }:
    let
      mkCond =
        filename: cond:
        lib.optional (lib.pathIsRegularFile /.${path}/${filename} && cond) /.${path}/${filename};
      options = mkCond "options.nix" (_: true);
      hm = mkCond "home-manager.nix" flags.isHm;
      nixos = mkCond "system-nixos.nix" flags.isNixos;
      nix-darwin = mkCond "system-darwin.nix" flags.isNixDarwin;
      system-all = mkCond "system-all.nix" flags.isSystem;
    in
    {
      imports = options ++ hm ++ nixos ++ nix-darwin ++ system-all;
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
    importSiblings
    mkCopyActivationScript
    mkHmProgramModule
    mkModule
    mkProfile
    mkProfileSet
    mkSimpleProgram
    mkSimpleProgramByName
    mkSimpleProgramImports
    mkSimpleProgramModule
    recurseFirstMatching
    recurseFirstMatchingIncludingSibling
    recursiveMap
    setCaskHash
    smartImport
    ;
}
