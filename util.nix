{
  lib,
  fish,
  writeShellScriptBin,
  writeTextFile,
  ...
}:
let
  inherit (builtins)
    attrNames
    isList
    isAttrs
    hasAttr
    map
    concatStringsSep
    readDir
    ;
  inherit (lib)
    flatten
    isStringLike
    escapeShellArg
    isValidPosixName
    ;
  inherit (lib.attrsets) foldlAttrs filterAttrs;

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
    dir
    |> readDir
    |> filterAttrs (_: type: type == "directory")
    |> attrNames
    |> map (d: /.${dir}/${d})
    |> map (recurseFirstMatchingIncludingSibling file)
    |> flatten;
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
    { lib, config, ... }:
    mkModule {
      options.gipphe.programs.${name}.enable = lib.mkEnableOption name;
      hm = lib.mkIf config.gipphe.programs.${name}.enable { home.packages = [ package ]; };
    };

  # Version of `mkSimpleProgrma` that uses the passed name to fetch the package
  # from `pkgs`.
  mkSimpleProgramModule = name: {
    imports = [ ({ pkgs, ... }@args: mkSimpleProgram name pkgs.${name} args) ];
  };

  mkProfile = name: cfg: {
    imports = [
      (
        { lib, config, ... }:
        {
          options.gipphe.profiles.${name}.enable = lib.mkEnableOption "${name} profile";
          config = lib.mkIf config.gipphe.profiles.${name}.enable cfg;
        }
      )
    ];
  };

  mkProgram = mkToggledModule [ "programs" ];
  mkEnvironment = mkToggledModule [ "environment" ];
  mkWallpaper = mkToggledModule [
    "environment"
    "wallpaper"
  ];

  # Creates a module with an automatically created `enable` options for the
  # given name, and injects an `lib.mkIf` into each of `hm`, `system-nixos`,
  # `system-darwin`, `system-all` and `shared` that toggles the module based on
  # said option.
  mkToggledModule =
    type:
    {
      name,
      options ? { },
      hm ? { },
      system-nixos ? { },
      system-darwin ? { },
      system-droid ? { },
      system-all ? { },
      shared ? { },
    }:
    {
      imports = [
        (
          { lib, config, ... }:
          let
            optPath = [ "gipphe" ] ++ type ++ (lib.splitString "." name) ++ [ "enable" ];
            isEnabled = lib.attrByPath optPath false config;
            injectMkIf =
              mod:
              let
                imports = mod.imports or [ ];
                config =
                  mod.config or (builtins.removeAttrs mod [
                    "imports"
                    "options"
                  ]);
                options = mod.options or { };
                rest = builtins.intersectAttrs {
                  _file = "";
                  _module = "";
                } mod;
              in
              rest
              // {
                inherit options imports;
                config = lib.mkIf isEnabled config;
              };
          in
          mkModule {
            hm = injectMkIf hm;
            system-nixos = injectMkIf system-nixos;
            system-darwin = injectMkIf system-darwin;
            system-droid = injectMkIf system-droid;
            system-all = injectMkIf system-all;
            shared = {
              imports = [
                { inherit options; }
                { options = lib.setAttrByPath optPath (lib.mkEnableOption name); }
                (injectMkIf shared)
              ];
            };
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
      system-droid ? { },
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
              ++ lib.optional flags.isNixOnDroid system-droid
              ++ lib.optional flags.isSystem system-all;
          }
        )
      ];
    };

  toFishShellVar =
    name: value:
    lib.throwIfNot (isValidPosixName name) "toFishShellVar: ${name} is not a valid shell variable name"
      (
        if isAttrs value && !isStringLike value then
          "set ${name} ${
            concatStringsSep " " (lib.mapAttrsToList (n: v: "${escapeShellArg n}=${escapeShellArg v}"))
          }"
        else if isList value then
          "set ${name} ${concatStringsSep " " (map (v: escapeShellArg v) value)}"
        else
          "set ${name} ${escapeShellArg value}"
      );

  writeFishApplication =
    {
      name,
      text,
      runtimeInputs ? [ ],
      runtimeEnv ? null,
      meta ? { },
      checkPhase ? null,
      derivationArgs ? { },
    }:
    writeTextFile {
      inherit name meta derivationArgs;
      executable = true;
      destination = "/bin/${name}";
      allowSubstitutes = true;
      preferLocalBuild = false;
      text =
        let
          fishShell = writeShellScriptBin "fish-bare" ''
            ${lib.getExe fish} --no-config --private "$@"
          '';
        in
        ''
          #!${lib.getExe fishShell}
        ''
        + lib.optionalString (runtimeEnv != null) (
          lib.concatStrings (
            lib.mapAttrsToList (name: value: ''
              ${toFishShellVar name value}; set -gx ${name} ''$${name};
            '') runtimeEnv
          )
        )
        + lib.optionalString (runtimeInputs != [ ]) ''
          set -xp PATH ${concatStringsSep " " (map (p: "'${lib.getBin p}'") runtimeInputs)}
        ''
        + ''
          ${text}
        '';
      checkPhase =
        if checkPhase == null then
          # bash
          ''
            runHook preCheck
            ${lib.getExe fish} --no-execute "$target"
            runHook postCheck
          ''
        else
          checkPhase;
    };
  findSiblings =
    path:
    lib.pipe path [
      readDir
      (lib.attrsets.filterAttrs (name: _: name != "default.nix"))
      attrNames
      (map (x: /.${path}/${x}))
    ];

  storeFileName =
    prefix: path:
    let
      safeChars =
        [
          "+"
          "."
          "_"
          "?"
          "="
        ]
        ++ lib.lowerChars
        ++ lib.upperChars
        ++ lib.stringToCharacters "0123456789";
      empties = l: lib.genList (x: "") (lib.length l);
      unsafeInName = lib.stringToCharacters (lib.replaceStrings safeChars (empties safeChars) path);
      safeName = lib.replaceStrings unsafeInName (empties unsafeInName) path;
    in
    "${prefix}${safeName}";
in
{
  inherit
    findSiblings
    mkEnvironment
    mkModule
    mkProfile
    mkProgram
    mkSimpleProgram
    mkSimpleProgramModule
    mkToggledModule
    mkWallpaper
    recurseFirstMatching
    recurseFirstMatchingIncludingSibling
    setCaskHash
    storeFileName
    writeFishApplication
    ;
}
