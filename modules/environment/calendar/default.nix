{
  inputs,
  util,
  config,
  ...
}:
util.mkEnvironment {
  name = "calendar";
  homeManager = {
    sensitive.calendar = {
      enable = true;
      basePath = "Calendar";
    };
  };
}
