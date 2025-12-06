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
                _args = [ "Alt g" ];
                Write = 7;
              };
            };
            pane = {

              _children = [
                {
                  bind._args = [ "d" ];
                  bind.NewPane = "down";
                  bind.SwitchToMode = "locked";
                }
                {
                  bind._args = [ "e" ];
                  bind.TogglePaneEmbedOrFloating._args = [ ];
                  bind.SwitchToMode = "locked";
                }
                {
                  bind._args = [ "f" ];
                  bind.ToggleFocusFullscreen = "";
                  bind.SwitchToMode = "locked";
                }
                {
                  bind._args = [ "n" ];
                  bind.NewPane = "";
                  bind.SwitchToMode = "locked";
                }
                {
                  bind._args = [ "p" ];
                  bind.SwitchToMode = "normal";
                }
                {
                  bind._args = [ "r" ];
                  bind.NewPane = "right";
                  bind.SwitchToMode = "locked";
                }
                {
                  bind._args = [ "w" ];
                  bind.ToggleFloatingPanes = "";
                  bind.SwitchToMode = "locked";
                }
                {
                  bind._args = [ "x" ];
                  bind.CloseFocus = "";
                  bind.SwitchToMode = "locked";
                }
                {
                  bind._args = [ "z" ];
                  bind.TogglePaneFrames = "";
                  bind.SwitchToMode = "locked";
                }
              ];
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
                    _args = [ "\\\\" ];
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
            _children = [
              {
                shared_except = {
                  _args = [
                    "locked"
                    "entersearch"
                    "renametab"
                    "renamepane"
                  ];
                  bind = {
                    _args = [ "esc" ];
                    SwitchToMode = "locked";
                  };
                };
              }
              {
                shared_except = {
                  _args = [
                    "locked"
                    "entersearch"
                  ];
                  bind = {
                    _args = [ "enter" ];
                    SwitchToMode = "locked";
                  };
                };
              }
              {
                shared_except = {
                  _args = [
                    "locked"
                    "entersearch"
                    "renametab"
                    "renamepane"
                    "move"
                  ];
                  bind = {
                    _args = [ "m" ];
                    SwitchToMode = "move";
                  };
                };
              }
              {
                shared_except = {
                  _args = [
                    "locked"
                    "entersearch"
                    "search"
                    "renametab"
                    "renamepane"
                    "session"
                  ];
                  bind = {
                    _args = [ "o" ];
                    SwitchToMode = "session";
                  };
                };
              }
              {
                shared_except = {
                  _args = [
                    "locked"
                    "tab"
                    "entersearch"
                    "renametab"
                    "renamepane"
                  ];
                  bind._args = [ "t" ];
                  bind.SwitchToMode = "tab";
                };
              }
              {
                shared_except = {
                  _args = [
                    "locked"
                    "tab"
                    "scroll"
                    "entersearch"
                    "renametab"
                    "renamepane"
                  ];

                  bind._args = [ "s" ];
                  bind.SwitchToMode = "scroll";
                };
              }
              {
                shared_among = {
                  _args = [
                    "normal"
                    "resize"
                    "tab"
                    "scroll"
                    "prompt"
                    "tmux"
                  ];

                  bind._args = [ "p" ];
                  bind.SwitchToMode = "pane";
                };
              }
              {
                shared_except = {
                  _args = [
                    "locked"
                    "resize"
                    "pane"
                    "tab"
                    "entersearch"
                    "renametab"
                    "renamepane"
                  ];

                  bind._args = [ "r" ];
                  bind.SwitchToMode = "resize";
                };
              }
            ];
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
