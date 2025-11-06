{ pkgs, util, ... }:
let
  zellij-forgot = import ./plugins/zellij-forgot.nix { inherit pkgs; };
  room = import ./plugins/room.nix { inherit pkgs; };
in
util.mkProgram {
  name = "zellij";
  hm = {
    programs = {
      zellij = {
        enable = true;
        settings = {
          show_startup_tips = false;
          keybinds = {
            locked = {
              bind = {
                _args = "Alt g";
                Write = 7;
              };
            };
            tab = {
              _children = [
                {
                  bind = {
                    _args = [ "+" ];
                    NextSwapLayout = { };
                  };
                }
                {
                  bind = {
                    _args = [ "\\" ];
                    PreviousSwapLayout = { };
                  };
                }
              ];
            };
            normal._children = [
              {
                bind = {
                  _args = [ "Ctrl Shift y" ];
                  LaunchOrFocusPlugin = {
                    _args = [ "file:${zellij-forgot}" ];
                    floating = true;
                  };
                };
              }
              {
                bind = {
                  _args = [ "Ctrl y" ];
                  LaunchOrFocusPlugin = {
                    _args = [ "file:${room}" ];
                    floating = true;
                    ignore_case = true;
                    quick_jump = true;
                  };
                };
              }
            ];
            shared_among = {
              _args = [
                "normal"
                "locked"
              ];
              _children = [

                {
                  unbind = "Alt h";
                  bind = {
                    _args = [ "Ctrl h" ];
                    MoveFocusOrTab = "left";
                  };
                }
                {
                  unbind = "Alt j";
                  bind = {
                    _args = [ "Ctrl j" ];
                    MoveFocus = "down";
                  };
                }
                {
                  unbind = "Alt k";
                  bind = {
                    _args = [ "Ctrl k" ];
                    MoveFocus = "up";
                  };
                }
                {
                  unbind = "Alt l";
                  bind = {
                    _args = [ "Ctrl l" ];
                    MoveFocusOrTab = "right";
                  };
                }
              ];
            };
          };

          copy_on_select = true;
          ui = {
            pane_frames = {
              rounded_corners = false;
              hide_session_name = true;
            };
          };
          theme = "catppuccin-macchiato";
          default_mode = "locked";
          default_shell = "fish";
          pane_frames = false;
        };
      };

      fish.shellAbbrs = {
        zq = "zellij kill-session $ZELLIJ_SESSION_NAME";
        zj = "zellij";
      };
    };
  };
}
