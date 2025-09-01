{ util, config, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
util.mkProgram {
  name = "rofi";
  hm = {
    imports = [ ./1password.nix ];
    programs.rofi = {
      enable = true;
      theme = {
        #   "*" = {
        #     border-width = mkLiteral "3px";
        #   };
        #
        configuration = {
          modi = "drun,run";
          font = "Fira Sans 11";
          show-icons = false;
          icon-theme = "kora";
          display-drun = "APPS";
          display-run = "RUN";
          display-filebrowser = "FILES";
          display-window = "WINDOW";
          hover-select = false;
          scroll-method = mkLiteral "1";
          me-select-entry = "";
          me-accept-entry = "MousePrimary";
          drun-display-format = "{name};";
          window-format = "{w}; · {c} · {t}";
        };

        window = {
          width = mkLiteral "600px";
          x-offset = mkLiteral "0px";
          y-offset = mkLiteral "65px";
          spacing = mkLiteral "0px";
          padding = mkLiteral "0px";
          margin = mkLiteral "0px";
          # color = mkLiteral "#FFFFFF";
          border = mkLiteral "@border-width";
          # border-color = mkLiteral "#FFFFFF";
          cursor = "default";
          transparency = "real";
          location = mkLiteral "north";
          anchor = mkLiteral "north";
          fullscreen = false;
          enabled = true;
          border-radius = mkLiteral "10px";
          # background-color = mkLiteral "transparent";
        };
        #
        #   # ---- Mainbox ----
        #   mainbox = {
        #     enabled = true;
        #     orientation = mkLiteral "horizontal";
        #     spacing = mkLiteral "0px";
        #     margin = mkLiteral "0px";
        #     # background-color = mkLiteral "@background";
        #     children = [ "listbox" ];
        #   };
        #
        #   # ---- Imagebox ----
        #   imagebox = {
        #     padding = mkLiteral "18px";
        #     # background-color = mkLiteral "transparent";
        #     orientation = mkLiteral "vertical";
        #     children = [
        #       "inputbar"
        #       "dummy"
        #       "mode-switcher"
        #     ];
        #   };
        #
        #   # ---- Listbox ----
        #   listbox = {
        #     spacing = mkLiteral "20px";
        #     # background-color = mkLiteral "transparent";
        #     orientation = mkLiteral "vertical";
        #     children = [
        #       "inputbar"
        #       "message"
        #       "listview"
        #     ];
        #   };
        #
        #   # ---- Dummy ----
        #   dummy = {
        #     # background-color = mkLiteral "transparent";
        #   };
        #
        #   # ---- Inputbar ----
        #   inputbar = {
        #     enabled = true;
        #     # text-color = mkLiteral "@foreground";
        #     spacing = mkLiteral "10px";
        #     padding = mkLiteral "15px";
        #     border-radius = mkLiteral "0px";
        #     # border-color = mkLiteral "@foreground";
        #     # background-color = mkLiteral "@background";
        #     children = [
        #       "textbox-prompt-colon"
        #       "entry"
        #     ];
        #   };
        #
        #   textbox-prompt-colon = {
        #     enabled = true;
        #     expand = false;
        #     padding = mkLiteral "0px 5px 0px 0px";
        #     str = "";
        #     # background-color = mkLiteral "transparent";
        #     # text-color = mkLiteral "inherit";
        #   };
        #
        #   entry = {
        #     enabled = true;
        #     # background-color = mkLiteral "transparent";
        #     # text-color = mkLiteral "inherit";
        #     cursor = mkLiteral "text";
        #     placeholder = "Search";
        #     # placeholder-color = mkLiteral "inherit";
        #   };
        #
        #   # ---- Mode Switcher ----
        #   mode-switcher = {
        #     enabled = true;
        #     spacing = mkLiteral "20px";
        #     # background-color = mkLiteral "transparent";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   button = {
        #     padding = mkLiteral "10px";
        #     border-radius = mkLiteral "10px";
        #     # background-color = mkLiteral "@background";
        #     # text-color = mkLiteral "inherit";
        #     cursor = mkLiteral "pointer";
        #     border = mkLiteral "0px";
        #   };
        #
        #   "button selected" = {
        #     # background-color = mkLiteral "@color11";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   # ---- Listview ----
        #   listview = {
        #     enabled = true;
        #     columns = mkLiteral "1";
        #     lines = mkLiteral "8";
        #     cycle = false;
        #     dynamic = false;
        #     scrollbar = false;
        #     layout = mkLiteral "vertical";
        #     reverse = false;
        #     fixed-height = true;
        #     fixed-columns = true;
        #     spacing = mkLiteral "0px";
        #     padding = mkLiteral "10px";
        #     margin = mkLiteral "0px";
        #     # background-color = mkLiteral "@background";
        #     border = mkLiteral "0px";
        #   };
        #
        #   # ---- Element ----
        #   element = {
        #     enabled = true;
        #     padding = mkLiteral "10px";
        #     margin = mkLiteral "5px";
        #     cursor = mkLiteral "pointer";
        #     # background-color = mkLiteral "@background";
        #     border-radius = mkLiteral "10px";
        #     border = mkLiteral "@border-width";
        #   };
        #
        #   "element normal.normal" = {
        #     # background-color = mkLiteral "inherit";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   "element normal.urgent" = {
        #     # background-color = mkLiteral "inherit";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   "element normal.active" = {
        #     # background-color = mkLiteral "inherit";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   "element selected.normal" = {
        #     # background-color = mkLiteral "@color11";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   "element selected.urgent" = {
        #     # background-color = mkLiteral "inherit";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   "element selected.active" = {
        #     # background-color = mkLiteral "inherit";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   "element alternate.normal" = {
        #     # background-color = mkLiteral "inherit";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   "element alternate.urgent" = {
        #     # background-color = mkLiteral "inherit";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   "element alternate.active" = {
        #     # background-color = mkLiteral "inherit";
        #     # text-color = mkLiteral "@foreground";
        #   };
        #
        #   element-icon = {
        #     # background-color = mkLiteral "transparent";
        #     # text-color = mkLiteral "inherit";
        #     size = mkLiteral "32px";
        #     cursor = mkLiteral "inherit";
        #   };
        #
        #   element-text = {
        #     # background-color = mkLiteral "transparent";
        #     # text-color = mkLiteral "inherit";
        #     cursor = mkLiteral "inherit";
        #     vertical-align = mkLiteral "0.5";
        #     horizontal-align = mkLiteral "0.0";
        #   };
        #
        #   /**
        #     ***----- Message -----****
        #   */
        #   message = {
        #     # background-color = mkLiteral "transparent";
        #     border = mkLiteral "0px";
        #     margin = mkLiteral "20px 0px 0px 0px";
        #     padding = mkLiteral "0px";
        #     spacing = mkLiteral "0px";
        #     border-radius = mkLiteral "10px";
        #   };
        #
        #   textbox = {
        #     padding = mkLiteral "15px";
        #     margin = mkLiteral "0px";
        #     border-radius = mkLiteral "0px";
        #     # background-color = mkLiteral "@background";
        #     # text-color = mkLiteral "@foreground";
        #     vertical-align = mkLiteral "0.5";
        #     horizontal-align = mkLiteral "0.0";
        #   };
        #
        #   error-message = {
        #     padding = mkLiteral "15px";
        #     border-radius = mkLiteral "20px";
        #     # background-color = mkLiteral "@background";
        #     # text-color = mkLiteral "@foreground";
        #   };
      };
    };
    gipphe.core.wm.binds = [
      {
        mod = "Mod";
        key = "space";
        action.spawn = "${config.programs.rofi.package}/bin/rofi -show drun";
      }
    ];
  };
}
