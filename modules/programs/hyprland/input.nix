{
  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "no";
    kb_variant = "";
    kb_model = "";
    # xkg options are sparsely documented, from what I can find. The
    # following descriptions are taken from the following sources:
    # - https://medium.com/@damko/a-simple-humble-but-comprehensive-guide-to-xkb-for-linux-6f1ad5e13450
    # - https://wiki.archlinux.org/title/Xorg/Keyboard_configuration
    #
    # Seems the `xkeyboard-config` package also has a list of possible rules to use:
    # /nix/store/<hash>-xkeyboard-config-<version>/share/xkeyboard-config-<major-version>/rules/base.lst
    # That file lists all rules and a short description for each.
    #
    # Options:
    # - nbsp:none : Disable inputting NBSP when pressing AltGr+Space
    #
    # - compose:menu : Use the menu key as the compose key. The compose
    # key triggers composition mode, where diacritic characters can be
    # combined with letters, for eaxample. Unsure how to configure compose key combinations in Wayland, but this is usually done through `~/.XCompose`.
    # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Key_combinations
    #
    # - eurosign:5 : Set the lv3 key for the Euro sign character. This
    # means, with the default lv3 key, you press AltGr+5 to write out a
    # Euro sign.
    #
    # - rupeesign:4 : Set the lv3 key for the Rupee sign character. This
    # means, with the default lv3 key, you press AltGr+4 to write out a
    # Rupee sign sign.
    #
    # - shift:both_capslock : Activates caps lock by pressing both shift
    # keys at the same time.
    #
    # - lv3:rwin_switch : Sets which key activates the 3rd level modifier.
    # It is used to printt he symbols displayed on the right side of some
    # keyboard keys, like "£${}" on Nordic keyboards. In this case, lv3
    # is the right window key, but you can set it to something else. By
    # default, I believe this is AltGr. Fun fact, "AltGr" stands for
    # "Alternate Graphic".
    #
    # - grp:<key> : Change keyboard layout with Alt+Shift.
    # Supports the following keys:
    #   - alt_shift_toggle : Alt+Shift
    #   - alts_toggle : Alt. Buggy, do not use.
    #   - caps_toggle : Caps lock
    #   - win_space_toggle : Super+Space
    #   - Possibly others that I have yet to find documented anywhere.
    #
    # - terminate:ctrl_alt_bksp : Terminare Xorg with Ctrl+Alt+Backspace.
    # Unsure what this does in Wayland.
    #
    # - ctrl:swapcaps : Swap caps lock with left control.
    #
    # - keypad:pointerkeys : Enable mouse keys. Not to be confused with
    # the actual keys on the mouse; mouse keys moves the mouse on the
    # screen using keyboard keys. This option makes Shift+NumLock toggle
    # mouse keys.
    kb_options = "nbsp:none,compose:menu,eurosign:5,caps:escape";
    kb_rules = "";
    numlock_by_default = true;

    follow_mouse = 1;

    touchpad = {
      natural_scroll = false;
    };

    sensitivity = 0; # -1.0 - 1.0, 0 means no modification
  };
}
