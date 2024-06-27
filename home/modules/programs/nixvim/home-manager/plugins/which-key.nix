{
  programs.nixvim.plugins.which-key = {
    enable = true;
    registrations = {
      mode = [
        "n"
        "v"
      ];
      "g" = "+goto";
      "gs" = "+surround";
      "z" = "+fold";
      "]" = "+next";
      "[" = "+prev";
      "<leader><tab>" = "+tabs";
      "<leader>b" = "+buffer";
      "<leader>c" = "+code";
      "<leader>f" = "+file/find";
      "<leader>g" = "+git";
      "<leader>gh" = "+hunks";
      "<leader>q" = "+quit/session";
      "<leader>s" = "+search";
      "<leader>u" = "+ui";
      "<leader>w" = "+windows";
      "<leader>x" = "+diagnostics/quickfix";
    };
  };
}
