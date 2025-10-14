# Converted from https://github.com/abenz1267/walker/blob/1e9f0cb45d0ca56fd8b902427f1408ada53a3068/resources/config.toml
{
  click_to_close = true;
  close_when_open = true;
  debug = false;
  disable_mouse = false;
  exact_search_prefix = "'";
  force_keyboard_focus = false;
  global_argument_delimiter = "#";
  keybinds = {
    close = [ "Escape" ];
    next = [ "Down" ];
    previous = [ "Up" ];
    quick_activate = [
      "F1"
      "F2"
      "F3"
      "F4"
    ];
    resume_last_query = [ "ctrl r" ];
    toggle_exact = [ "ctrl e" ];
  };
  placeholders = {
    default = {
      input = "Search";
      list = "No Results";
    };
  };
  providers = {
    actions = {
      archlinuxpkgs = [
        {
          action = "install";
          bind = "Return";
          default = true;
        }
        {
          action = "remove";
          bind = "Return";
        }
      ];
      bluetooth = [
        {
          action = "find";
          after = "AsyncClearReload";
          bind = "ctrl f";
          global = true;
        }
        {
          action = "trust";
          after = "AsyncReload";
          bind = "ctrl t";
        }
        {
          action = "untrust";
          after = "AsyncReload";
          bind = "ctrl t";
        }
        {
          action = "pair";
          after = "AsyncReload";
          bind = "Return";
        }
        {
          action = "remove";
          after = "AsyncReload";
          bind = "ctrl d";
        }
        {
          action = "connect";
          after = "AsyncReload";
          bind = "Return";
        }
        {
          action = "disconnect";
          after = "AsyncReload";
          bind = "Return";
        }
      ];
      calc = [
        {
          action = "copy";
          bind = "Return";
          default = true;
        }
        {
          action = "delete";
          after = "AsyncReload";
          bind = "ctrl d";
        }
        {
          action = "save";
          after = "AsyncClearReload";
          bind = "ctrl s";
        }
      ];
      clipboard = [
        {
          action = "copy";
          bind = "Return";
          default = true;
        }
        {
          action = "remove";
          after = "ClearReload";
          bind = "ctrl d";
        }
        {
          action = "remove_all";
          after = "ClearReload";
          bind = "ctrl shift d";
          global = true;
          label = "clear";
        }
        {
          action = "toggle_images";
          after = "ClearReload";
          bind = "ctrl i";
          global = true;
          label = "toggle images";
        }
        {
          action = "edit";
          bind = "ctrl o";
        }
      ];
      desktopapplications = [
        {
          action = "start";
          bind = "Return";
          default = true;
        }
        {
          action = "start:keep";
          after = "KeepOpen";
          bind = "shift Return";
          label = "open+next";
        }
        {
          action = "pin";
          after = "AsyncReload";
          bind = "ctrl p";
        }
        {
          action = "unpin";
          after = "AsyncReload";
          bind = "ctrl p";
        }
        {
          action = "pinup";
          after = "AsyncReload";
          bind = "ctrl n";
        }
        {
          action = "pindown";
          after = "AsyncReload";
          bind = "ctrl m";
        }
      ];
      dmenu = [
        {
          action = "select";
          bind = "Return";
          default = true;
        }
      ];
      fallback = [
        {
          action = "menus:open";
          after = "Nothing";
          label = "open";
        }
        {
          action = "erase_history";
          after = "AsyncReload";
          bind = "ctrl h";
          label = "clear hist";
        }
      ];
      files = [
        {
          action = "open";
          bind = "Return";
          default = true;
        }
        {
          action = "opendir";
          bind = "ctrl Return";
          label = "open dir";
        }
        {
          action = "copypath";
          bind = "ctrl shift c";
          label = "copy path";
        }
        {
          action = "copyfile";
          bind = "ctrl c";
          label = "copy file";
        }
      ];
      providerlist = [
        {
          action = "activate";
          after = "ClearReload";
          bind = "Return";
          default = true;
        }
      ];
      runner = [
        {
          action = "run";
          bind = "Return";
          default = true;
        }
        {
          action = "runterminal";
          bind = "shift Return";
          label = "run in terminal";
        }
      ];
      symbols = [
        {
          action = "run_cmd";
          bind = "Return";
          default = true;
          label = "select";
        }
      ];
      todo = [
        {
          action = "save";
          after = "ClearReload";
          bind = "Return";
          default = true;
        }
        {
          action = "delete";
          after = "ClearReload";
          bind = "ctrl d";
        }
        {
          action = "active";
          after = "ClearReload";
          bind = "Return";
        }
        {
          action = "inactive";
          after = "ClearReload";
          bind = "Return";
        }
        {
          action = "done";
          after = "ClearReload";
          bind = "ctrl f";
        }
        {
          action = "clear";
          after = "ClearReload";
          bind = "ctrl x";
          global = true;
        }
      ];
      unicode = [
        {
          action = "run_cmd";
          bind = "Return";
          default = true;
          label = "select";
        }
      ];
      websearch = [
        {
          action = "search";
          bind = "Return";
          default = true;
        }
      ];
    };
    clipboard = {
      time_format = "%d.%m. - %H:%M";
    };
    default = [
      "desktopapplications"
      "calc"
      "runner"
      "menus"
      "websearch"
    ];
    empty = [ "desktopapplications" ];
    max_results = 50;
    max_results_provider = { };
    prefixes = [
      {
        prefix = ";";
        provider = "providerlist";
      }
      {
        prefix = ">";
        provider = "runner";
      }
      {
        prefix = "/";
        provider = "files";
      }
      {
        prefix = ".";
        provider = "symbols";
      }
      {
        prefix = "!";
        provider = "todo";
      }
      {
        prefix = "=";
        provider = "calc";
      }
      {
        prefix = "@";
        provider = "websearch";
      }
      {
        prefix = ":";
        provider = "clipboard";
      }
    ];
    sets = [ ];
  };
  selection_wrap = false;
  shell = {
    anchor_bottom = true;
    anchor_left = true;
    anchor_right = true;
    anchor_top = true;
  };
  theme = "default";
}
