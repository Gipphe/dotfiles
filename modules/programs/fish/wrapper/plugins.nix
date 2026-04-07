{ lib, config, ... }:
let
  pluginModule = lib.types.submodule {
    options = {
      src = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path to the plugin folder.

          Relevant pieces will be added to the fish function path and
          the completion path. The {file}`init.fish` and
          {file}`key_binding.fish` files are sourced if
          they exist.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        description = ''
          The name of the plugin.
        '';
      };
    };
  };
in
{
  options.plugins = lib.mkOption {
    type = lib.types.listOf pluginModule;
    default = [ ];
    example = lib.literalExpression /* nix */ ''
      [
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
            sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
          };
        }

        # oh-my-fish plugins are stored in their own repositories, which
        # makes them simple to import into home-manager.
        {
          name = "fasd";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-fasd";
            rev = "38a5b6b6011106092009549e52249c6d6f501fba";
            sha256 = "06v37hqy5yrv5a6ssd1p3cjd9y3hnp19d3ab7dag56fs1qmgyhbs";
          };
        }
      ]
    '';
    description = ''
      The plugins to source in
      {file}`conf.d/99plugins.fish`.
    '';
  };

  # Each plugin gets a corresponding conf.d/plugin-NAME.fish file to load in
  # the paths and any initialization scripts.
  config = lib.mkIf (lib.length config.plugins > 0) {
    constructFiles = lib.mkMerge (
      map (plugin: {
        ${plugin.name} = {
          relPath = "${config.configDir}/conf.d/plugin-${plugin.name}.fish";
          content = /* fish */ ''
            # Plugin ${plugin.name}
            set -l plugin_dir ${plugin.src}

            # Set paths to import plugin components
            if test -d $plugin_dir/functions
              set fish_function_path $fish_function_path[1] $plugin_dir/functions $fish_function_path[2..-1]
            end

            if test -d $plugin_dir/completions
              set fish_complete_path $fish_complete_path[1] $plugin_dir/completions $fish_complete_path[2..-1]
            end

            # Source initialization code if it exists.
            if test -d $plugin_dir/conf.d
              for f in $plugin_dir/conf.d/*.fish
                source $f
              end
            end

            if test -f $plugin_dir/key_bindings.fish
              source $plugin_dir/key_bindings.fish
            end

            if test -f $plugin_dir/init.fish
              source $plugin_dir/init.fish
            end
          '';
        };
      }) config.plugins
    );
  };
}
