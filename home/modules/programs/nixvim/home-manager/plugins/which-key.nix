let
  group = __unkeyed-1: group: {
    inherit __unkeyed-1 group;
    mode = [
      "n"
      "v"
    ];
  };
in
{
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings.spec = [
      (group "g" "+goto")
      (group "gs" "+surround")
      (group "z" "+fold")
      (group "]" "+next")
      (group "[" "+prev")
      (group "<leader><tab>" "+tabs")

      (group "<leader>b" "+buffer")
      (group "<leader>c" "+code")
      (group "<leader>f" "+file/find")
      (group "<leader>g" "+git")
      (group "<leader>gh" "+hunks")
      (group "<leader>q" "+quit/session")
      (group "<leader>s" "+search")
      (group "<leader>u" "+ui")
      (group "<leader>w" "+windows")
      (group "<leader>x" "+diagnostics/quickfix")
    ];
  };
}
