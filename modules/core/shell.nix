{ lib, util, ... }:
util.mkModule {
  options.gipphe.core.shell = {
    abbrs = lib.mkOption {
      description = "Shell-agnostic abbreviations. Will be implemented as aliases for shells that do not support abbreviations.";
      type = with lib.types; attrsOf str;
      default = { };
    };
    aliases = lib.mkOption {
      description = "Shell-agnostic aliases.";
      default = { };
      type =
        with lib.types;
        attrsOf (
          either str (submodule {
            options = {
              expansion = lib.mkOption {
                description = "Text to expand to.";
                type = lib.types.str;
              };
              position = lib.mkOption {
                description = "Where the expansion can happen.";
                type =
                  with lib.types;
                  enum [
                    "anywhere"
                    "command"
                  ];
              };
            };
          })
        );
    };
  };
}
