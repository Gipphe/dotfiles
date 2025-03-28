{ util, inputs, ... }:
util.mkProgram {
  name = "nixCats";
  hm = {
    imports = [ inputs.nixCats.homeModules.default ];
    config.nvim.enable = true;
  };
}
