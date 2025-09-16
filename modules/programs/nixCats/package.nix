{
  inputs,
  self,
  ...
}:
let
  inherit (inputs) nixpkgs nixCats;
  inherit (nixCats) utils;
  luaPath = "${./.}";
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  # the following extra_pkg_config contains any values
  # which you want to pass to the config set of nixpkgs
  # import nixpkgs { config = extra_pkg_config; inherit system; }
  # will not apply to module imports
  # as that will have your system values
  extra_pkg_config = {
    # allowUnfree = true;
  };
  # management of the system variable is one of the harder parts of using flakes.

  # so I have done it here in an interesting way to keep it out of the way.
  # It gets resolved within the builder itself, and then passed to your
  # categoryDefinitions and packageDefinitions.

  # this allows you to use ${pkgs.system} whenever you want in those sections
  # without fear.

  # sometimes our overlays require a ${system} to access the overlay.
  # Your dependencyOverlays can either be lists
  # in a set of ${system}, or simply a list.
  # the nixCats builder function will accept either.
  # see :help nixCats.flake.outputs.overlays
  dependencyOverlays = # (import ./overlays inputs) ++
    [
      # This overlay grabs all the inputs named in the format
      # `plugins-<pluginName>`
      # Once we add this overlay to our nixpkgs, we are able to
      # use `pkgs.neovimPlugins`, which is a set of our plugins.
      (utils.standardPluginOverlay inputs)
      # add any other flake overlays here.

      # when other people mess up their overlays by wrapping them with system,
      # you may instead call this function on their overlay.
      # it will check if it has the system in the set, and if so return the desired overlay
      # (utils.fixSystemizedOverlay inputs.codeium.overlays
      #   (system: inputs.codeium.overlays.${system}.default)
      # )
    ];

  # see :help nixCats.flake.outputs.categories
  # and
  # :help nixCats.flake.outputs.categoryDefinitions.scheme
  categoryDefinitions =
    { pkgs, ... }:
    let
      marp-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "marp-nvim";
        version = "2025-04-02";
        src = pkgs.fetchFromGitHub {
          owner = "aca";
          repo = "marp.nvim";
          rev = "58d9544d0fa2d78b538e2e2a9b4c018228af0bfe";
          hash = "sha256-aVQsE3aQRH0t7FRtOYlc4+sqcycpa0VBGrww2anEJmA=";
        };
      };
      venv-selector-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "venv-selector.nvim";
        version = "2025-04-02";
        src = pkgs.fetchFromGitHub {
          owner = "linux-cultist";
          repo = "venv-selector.nvim";
          rev = "8d7224af54a02f9385c4f77eadf21e5b2407d860";
          hash = "sha256-09Zv4nMl9iw3ZrlGIROERcvlDXf1z5JpAEIyYdaqgIA=";
        };
      };
      pnpm-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "pnpm.nvim";
        version = "2025-04-02";
        src = pkgs.fetchFromGitHub {
          owner = "lukahartwig";
          repo = "pnpm.nvim";
          rev = "b44002c8da2ef68a023ff2c3fa2c454c6c7fa279";
          hash = "sha256-iJ7f4+nB04rlkLr/faCrBUsbgiRT7f9IDQMM0R6xT9M=";
        };
      };
    in
    {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = with pkgs; {
        general = [
          fd
          fourmolu
          haskellPackages.cabal-fmt
          markdownlint-cli
          nix-doc
          nixfmt
          ripgrep
          shfmt
          stdenv.cc.cc
          stylua
          universal-ctags
          self.packages.${pkgs.system}.prettier-with-plugins
        ];

        full = with pkgs; [
          bash-language-server
          dockerfile-language-server
          elmPackages.elm-language-server
          fish-lsp
          gopls
          kdePackages.qtdeclarative
          lemminx
          lua-language-server
          marksman
          metals
          nil
          nixd
          opentofu
          powershell
          powershell-editor-services
          ruff
          rust-analyzer
          sqls
          tailwindcss-language-server
          terraform-ls
          tofu-ls
          typescript-language-server
          vscode-langservers-extracted
          yaml-language-server
        ];

        basedpyright = [ basedpyright ];

        haskell = with haskellPackages; [
          fast-tags
          ghci-dap
          haskell-debug-adapter
          haskell-language-server
          hoogle
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = with pkgs.vimPlugins; {
        general = [
          blink-cmp
          bufferline-nvim
          catppuccin-nvim
          conform-nvim
          flash-nvim
          gitsigns-nvim
          grapple-nvim
          guess-indent-nvim
          hunk-nvim
          lazy-nvim
          luasnip
          mini-nvim
          neoconf-nvim
          nvim-autopairs
          nvim-highlight-colors
          nvim-spectre
          nvim-treesitter-context
          nvim-treesitter-refactor
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          oil-nvim
          persistence-nvim
          plenary-nvim
          promise-async
          snacks-nvim
          tiny-inline-diagnostic-nvim
          trouble-nvim
          undotree
          vim-css-color
          vim-go
          vim-illuminate
          vim-matchup
          virt-column-nvim
          which-key-nvim
          wilder-nvim
          yuck-vim
          zellij-nav-nvim
        ];

        full = with pkgs.vimPlugins; [
          fidget-nvim
          lazydev-nvim
          marp-nvim
          no-neck-pain-nvim
          nvim-dap
          nvim-dap-python
          nvim-dap-ui
          nvim-lspconfig
          nvim-notify
          otter-nvim
          pnpm-nvim
          todo-comments-nvim
          venv-selector-nvim
        ];

        haskell = [
          haskell-tools-nvim
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
      # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
      # I just put them all in startupPlugins. I could have put them all in here instead.
      # optionalPlugins = { };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        # general = with pkgs; [
        # libgit2
        # ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        # test = {
        #   CATTESTVAR = "It worked!";
        # };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        # test = [
        #   ''--set CATTESTVAR2 "It worked again!"''
        # ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python.libraries = {
        # test = (_: [ ]);
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        # test = [ (_: [ ]) ];
      };
    };

  # And then build a package with specific categories from above here:
  # All categories you wish to include must be marked true,
  # but false may be omitted.
  # This entire set is also passed to nixCats for querying within the lua.

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions = {
    # These are the names of your packages
    # you can include as many as you wish.
    nvim =
      { pkgs, ... }:
      {
        # they contain a settings set defined above
        # see :help nixCats.flake.outputs.settings
        settings = {
          wrapRc = true;
          # IMPORTANT:
          # your alias may not conflict with your other packages.
          aliases = [ "vim" ];
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        };
        categories = {
          general = true;
          full = true;

          haskell = true;
          basedpyright = true;

          # we can pass whatever we want actually.
          have_nerd_font = true;

          droid = false;

          powershell_es = "${pkgs.powershell-editor-services}";
        };

        extra = {
          nixd = {
            nixpkgs = ''import ${pkgs.path} {}'';
            home_manager = ''(builtins.getFlake "${inputs.self}").nixosConfigurations.argon.options.home-manager.users.type.getSubOptions []'';
            nixos_options = ''(builtins.getFlake "${inputs.self}").nixosConfigurations.argon.options'';
            darwin_options = ''(builtins.getFlake "${inputs.self}").darwinConfigurations.silicon.options'';
            droid_options = ''(builtins.getFlake "${inputs.self}").nixOnDroidConfigurations.helium.options'';
          };
        };
      };

    droid =
      args:
      let
        pkg = packageDefinitions.nvim args;
      in
      pkg
      // {
        categories = pkg.categories // {
          droid = true;
        };
      };
  };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
  defaultPackageName = "nvim";
in

# see :help nixCats.flake.outputs.exports
forEachSystem (
  system:
  let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit
        nixpkgs
        system
        dependencyOverlays
        extra_pkg_config
        ;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # these outputs will be wrapped with ${system} by utils.eachSystem

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one passed in here.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = '''';
      };
    };

  }
)
// (
  let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
  in
  {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  }
)
