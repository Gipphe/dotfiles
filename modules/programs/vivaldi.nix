{
  den.aspects.programs.vivaldi = { config, lib, ... }: {
    settings.default = lib.mkEnableOption "vivaldi as default browser";
    homeManager =
      { lib, pkgs, ... }:
      let
        pkg = pkgs.vivaldi.overrideAttrs (prevAttrs: {
          builInputs = (prevAttrs.buildInputs or [ ]) ++ [ pkgs.makeWrapper ];
          postInstall = ''
            ${prevAttrs.postInstall or ""}

            substituteInPlace $out/share/applications/vivaldi-stable.desktop \
              --replace-fail "vivaldi %U" "vivaldi --enable-blink-features=MiddleClickAutoscroll %U" \
              --replace-fail "vivaldi --new-window" "vivaldi --enable-blink-features=MiddleClickAutoscroll --new-window" \
              --replace-fail "vivaldi --incognito" "vivaldi --enable-blink-features=MiddleClickAutoscroll --incognito"
          '';
        });
      in
      {
        # TODO: Add `--enable-blink-features=MiddleClickAutoscroll` to desktop entry
        home = {
          packages = [ pkg ];
          sessionVariables = lib.mkIf config.settings.default {
            BROWSER = "${pkg}/bin/vivaldi";
          };
        };
        gipphe.core.wm.bind = lib.mkIf config.settings.default {
          "SUPER + B".action.spawn = "${pkg}/bin/vivaldi";
        };
      };
  };
}
