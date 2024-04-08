{
  programs.nixvim = {
    plugins.lint = {
      enable = true;
      lintersByFt = {
        fish = [ "fish" ];
      };
      autoCmd.event = [
        "BufWritePost"
        "BufReadPost"
        "InsertLeave"
      ];
    };
  };
}
