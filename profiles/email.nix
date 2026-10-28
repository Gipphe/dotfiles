{ util, ... }:
util.mkProfile {
  name = "email";
  shared.gipphe = {
    environment.email.enable = true;
    programs = {
      aerc.enable = true;
      himalaya.enable = true;
      mbsync.enable = true;
      neomutt.enable = true;
    };
  };
}
