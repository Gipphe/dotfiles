{
  pkgs,
  util,
  lib,
  config,
  ...
}:
util.mkModule {
  options.gipphe.programs.claude-code.skills = lib.mkOption {
    description = "Directories with skill data";
    default = [ ];
    type =
      with lib.types;
      attrsOf (oneOf [
        str
        path
        package
      ]);
  };
  shared.imports = lib.pipe ./. [
    builtins.readDir
    (lib.filterAttrs (_: type: type == "directory"))
    builtins.attrNames
    (map (p: ./${p}))
  ];
  homeManager.config = lib.mkIf config.gipphe.programs.claude-code.enable {
    wrappers.claude-code.addFlag = [
      "--add-dir"
      (pkgs.linkFarm "claude-code-skills" (
        lib.mapAttrs' (name: value: {
          name = ".claude/skills/${name}";
          inherit value;
        }) config.gipphe.programs.claude-code.skills
      ))
    ];
  };
}
