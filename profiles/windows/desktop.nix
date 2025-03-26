{ util, ... }:
util.mkNestedProfile [ "windows" "desktop" ] {
  windows = {
    chocolatey.programs = [ ];
  };
}
