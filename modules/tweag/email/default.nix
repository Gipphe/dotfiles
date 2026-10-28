{ util, ... }:
util.mkToggledModule [ "tweag" ] {
  name = "email";
  homeManager = {
    sensitive.email.tweag.enable = true;
  };
}
