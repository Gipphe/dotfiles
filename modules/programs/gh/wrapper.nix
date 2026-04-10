{
  lib,
  pkgs,
  wlib,
  config,
  ...
}:
let

  toYAML = lib.generators.toYAML { };
  yamlFormat = pkgs.formats.yaml { };

  settingsType = lib.types.submodule {
    freeformType = yamlFormat.type;
    # These options are only here for the `mkRenamedOptionModule` support
    options = {
      aliases = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        example = lib.literalExpression ''
          {
            co = "pr checkout";
            pv = "pr view";
          }
        '';
        description = ''
          Aliases that allow you to create nicknames for gh commands.
        '';
      };
      editor = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          The editor that gh should run when creating issues, pull requests, etc.
          If blank, will refer to environment.
        '';
      };
      git_protocol = lib.mkOption {
        type = lib.types.str;
        default = "https";
        example = "ssh";
        description = ''
          The protocol to use when performing Git operations.
        '';
      };
    };
  };
in
{
  imports = [ wlib.modules.default ];
  options = {
    settings = lib.mkOption {
      type = settingsType;
      default = { };
      description = "Configuration written to {file}`$XDG_CONFIG_HOME/gh/config.yml`.";
      example = lib.literalExpression ''
        {
          git_protocol = "ssh";

          prompt = "enabled";

          aliases = {
            co = "pr checkout";
            pv = "pr view";
          };
        };
      '';
    };

    gitCredentialHelper = {
      hosts = lib.mkOption {
        type = with lib.types; listOf str;
        default = [
          "https://github.com"
          "https://gist.github.com"
        ];
        description = "GitHub hosts to enable the gh git credential helper for";
        example = lib.literalExpression ''
          [ "https://github.com" "https://github.example.com" ]
        '';
      };
    };

    extensions = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = ''
        gh extensions, see <https://cli.github.com/manual/gh_extension>.
      '';
      example = lib.literalExpression "[ pkgs.gh-eco ]";
    };

    hosts = lib.mkOption {
      inherit (yamlFormat) type;
      default = { };
      description = "Host-specific configuration written to {file}`$XDG_CONFIG_HOME/gh/hosts.yml`.";
      example."github.com".user = "<your_username>";
    };
  };
  config = {
    package = lib.mkDefault pkgs.gh;
    env.GH_CONFIG_DIR = "${placeholder "out"}/config";
    constructFiles = {
      config = {
        relPath = "config/config.yml";
        content = toYAML config.settings;
      };
      hosts = lib.mkIf (config.hosts != { }) {
        relPath = "config/hosts.yml";
        content = toYAML config.hosts;
      };
    }
    // builtins.listToAttrs (
      map (p: {
        name = "config/extensions/${p.pname}";
        value = lib.getExe p;
      }) config.extensions
    );
    passthru.git.constructFiles.gitconfig.content = builtins.concatStringsSep "\n" (
      map (host: ''
        [credental "${host}"]
          helper = ""
          helper = "${config.package}/bin/gh auth git-credential"
      '') config.gitCredentialHelper.hosts
    );
    meta = {
      description.pre = ''
        To use this wrapped GitHub CLI as a credential helper for GitHub with Git, pass the `passthru.git` attribute on this wrapped package to your Git wrapper.

        ```nix
        wrappers.git.wrap ({
          # ...
        } // wrappers.gh.passthru.git)
        ```
      '';
    };
  };
}
