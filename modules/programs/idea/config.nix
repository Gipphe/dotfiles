{
  lib,
  config,
  flags,
  pkgs,
  ...
}:
let
  inherit (import ./utils.nix { inherit lib flags pkgs; }) darwinOptionsDir linuxOptionsDir;
  mkConfig = optionsDir: {
    "${optionsDir}/colors.scheme.xml".text = ''
      <application>
        <component name="EditorColorsManagerImpl">
          <global_color_scheme name="Catppuccin Macchiato" />
        </component>
      </application>
    '';
    "${optionsDir}/laf.xml".text = ''
      <application>
        <component name="LafManager">
          <laf themeId="com.github.catppuccin.macchiato.jetbrains" />
          <lafs-to-previous-schemes>
            <laf-to-scheme laf="ExperimentalDark" scheme="_@user_Catppuccin Macchiato" />
          </lafs-to-previous-schemes>
        </component>
      </application>
    '';
    "${optionsDir}/CatppuccinIcons.xml".text = ''
      <application>
        <component name="com.github.catppuccin.jetbrains_icons.settings.PluginSettingsState">
          <option name="variant" value="macchiato" />
        </component>
      </application>
    '';
    "${optionsDir}/editor-font.xml".text = ''
      <application>
        <component name="DefaultFont">
          <option name="VERSION" value="1" />
          <option name="FONT_FAMILY" value="FiraCode Nerd Font" />
          <option name="USE_LIGATURES" value="true" />
        </component>
      </application>
    '';
  };
  inherit (pkgs.stdenv) hostPlatform;
  darwinConfig = lib.mkIf hostPlatform.isDarwin { home.file = mkConfig darwinOptionsDir; };
  linuxConfig = lib.mkIf hostPlatform.isLinux { xdg.configFile = mkConfig linuxOptionsDir; };
in
{
  config = lib.mkIf config.gipphe.programs.idea-ultimate.enable (
    lib.mkMerge [
      darwinConfig
      linuxConfig
      {
        home.file.".ideavimrc".text = # vim
          ''
            nnoremap <SPACE> <Nop>
            let mapleader=" "

            Plug 'easymotion/vim-easymotion'
            Plug 'tpope/vim-surround'
            Plug 'tpope/vim-commentary'
            Plug 'machakann/vim-highlightedyank'
            Plug 'michaeljsmith/vim-indent-object'

            set number
            set relativenumber

            set scrolloff=8

            set visualbell
            set noerrorbells
            set clipboard=unnamedplus
            set incsearch

            set easymotion
            set quickscope
            set which-key

            set notimeout
            let g:highlightedyank_highlight_duration = "400"

            " vim-surround keybinds
            nmap gsa ys
            vmap gsa ys
            nmap gsr cs
            nmap gsd ds

            " vim-easymotion keybinds
            nmap s <Plug>(easymotion-s)

            nmap <Leader><Leader> <Action>(GotoFile)
            nmap <Leader>e <Action>(ActivateProjectToolWindow)
          '';
      }
    ]
  );
}
