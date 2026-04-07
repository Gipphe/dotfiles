{
  config,
  lib,
  pkgs,
  ...
}:
let
  completionModule = lib.types.submodule {
    options = {
      body = lib.mkOption {
        type = lib.types.lines;
        description = ''
          The completion file's body.
        '';
      };
    };
  };

  generateCompletions =
    let
      getName =
        attrs: attrs.name or "${attrs.pname or "«pname-missing»"}-${attrs.version or "«version-missing»"}";
    in
    package:
    pkgs.runCommand "${getName package}-fish-completions"
      {
        srcs = [
          package
        ]
        ++ lib.filter (p: p != null) (
          map (outName: package.${outName} or null) config.packagesExtraOutputs
        );
        nativeBuildInputs = [ pkgs.python3 ];
        buildInputs = [ config.package ];
        preferLocalBuild = true;
      }
      /* bash */ ''
        mkdir -p $out
        for src in $srcs; do
          if [ -d $src/share/man ]; then
            find -L $src/share/man -type f \
              -exec python ${config.package}/share/fish/tools/create_manpage_completions.py --directory $out {} + \
              > /dev/null
          fi
        done
      '';

  allCompletions =
    let
      cmp = (a: b: (a.meta.priority or 0) > (b.meta.priority or 0));
    in
    map generateCompletions (lib.sort cmp config.completions.packages);

  generatedCompletions =
    let
      # Paths later in the list will overwrite those already linked
      destructiveSymlinkJoin =
        args_@{
          name,
          preferLocalBuild ? true,
          allowSubstitutes ? false,
          postBuild ? "",
          ...
        }:
        let
          args =
            removeAttrs args_ [
              "name"
              "postBuild"
            ]
            // {
              # pass the defaults
              inherit preferLocalBuild allowSubstitutes;
            };
        in
        pkgs.runCommand name args ''

          mkdir -p $out
          for i in $paths; do
            if [ -z "$(find $i -prune -empty)" ]; then
              cp -srf $i/* $out
            fi
          done
          ${postBuild}
        '';

    in
    destructiveSymlinkJoin {
      name = "fish-wrapper-completions";
      paths = allCompletions;
    };

  customCompletions = lib.mapAttrs' (
    name: def:
    let
      path = "${config.configDir}/completions/${name}.fish";
    in
    {
      name = path;
      value = {
        relPath = path;
        content =
          let
            body = if lib.isAttrs def then def.body else def;
          in
          ''
            ${lib.strings.removeSuffix "\n" body}
          '';
      };
    }
  ) config.completions.custom;
in
{
  options.completions = {
    custom = lib.mkOption {
      type = with lib.types; attrsOf (either lines completionModule);
      default = { };
      example = lib.literalExpression /* nix */ ''
        {
          my-prog = '''
            complete -c myprog -s o -l output
          ''';

          my-app = {
            body = '''
              complete -c myapp -s -v
            ''';
          };
        }
      '';
      description = ''
        Custom fish completions. For more information see
        <https://fishshell.com/docs/current/completions.html>.
      '';
    };
    packages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      example = lib.literalExpression /* nix */ ''
        config.home.packages
      '';
      description = ''
        Set of packages for which to generate completions for using their man
        pages.
      '';
    };
    packagesExtraOutputs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression /* nix */ ''
        [ "build" "doc" "dev" ]
      '';
      description = ''
        Additional package outputs to include when building completions from
        package man pages.
      '';
    };
  };

  config.constructFiles = customCompletions;

  config.env.__all_completions_package_path =
    let
      allCompletionsPackage =
        pkgs.runCommand "fish-all-completions"
          {
            passAsFile = [ "allCompletions" ];
            inherit allCompletions;
          }
          ''
            mkdir -p $out
            cp "$allCompletionsPath" "$out/extra-completions"
          '';
    in
    allCompletionsPackage.outPath;

  config.init.interactiveShell = ''
    # add completions generated to $fish_complete_path
    begin
      set -l joined (string join " " $fish_complete_path)
      set -l prev_joined (string replace --regex "[^\s]*fish-wrapper-completions.*" "" $joined)
      set -l post_joined (string replace $prev_joined "" $joined)
      set -l prev (string split " " (string trim $prev_joined))
      set -l post (string split " " (string trim $post_joined))
      set fish_complete_path $prev "${generatedCompletions}" $post
    end
  '';
}
