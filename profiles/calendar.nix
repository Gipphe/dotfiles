{ util, ... }:
util.mkProfile {
  name = "calendar";
  shared.gipphe = {
    environment.calendar.enable = true;
    programs = {
      khal.enable = true;
      vdirsyncer.enable = true;
    };
  };
}
