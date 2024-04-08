{
  programs.nixvim = {
    plugins = {
      friendly-snippets.enable = true;
      luasnip = {
        enable = true;
        extraConfig = {
          history = true;
          delete_check_events = "TextChanged";
        };
      };
    };
    keymaps = [
      {
        key = "<tab>";
        action = ''function() return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>" end'';
        lua = true;
        mode = [ "i" ];
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        key = "<tab>";
        action = ''function() return require("luasnip").jump(1) end'';
        lua = true;
        mode = [ "s" ];
      }
      {
        key = "<s-tab>";
        action = ''function() return require("luasnip").jump(-1) end'';
        lua = true;
        mode = [ "s" ];
      }
    ];
  };
}
