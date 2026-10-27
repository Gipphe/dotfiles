{
  lib,
  util,
  config,
  ...
}:
util.mkEnvironment {
  name = "email";
  homeManager = {
    sensitive.email = {
      enable = true;
      maildirBasePath = "Mail";
    };
  };
}
