let
  inherit (import ../mapping-prefixes.nix) buffer;
  closeCommand = # lua
    ''
      function()
        local bd = require('bufdelete').bufdelete
        if vim.bo.modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
          if choice == 1 then -- Yes
            vim.cmd.write()
            bd(0)
          elseif choice == 2 then
            bd(0, true)
          end
        else
          bd(0)
        end
      end
    '';
in
{
  imports = [ ./bufferline.nix ];
  # gipphe.programs.nvf.settings.vim.tabline.bufferline.enable = true;
  programs.nvf.settings.vim = {
    tabline.nvimBufferline = {
      enable = true;
      mappings = {
        closeCurrent = "<leader>bd";
      };
      setupOpts.options = {
        close_command = closeCommand;
        modified_icon = "~";
        numbers = "buffer_id";
        sort_by = "insert_at_end";
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "${buffer.prefix}o";
        desc = "Delete other buffers";
        action = # lua
          ''
            function()
              local bd = ${closeCommand}
              local bufs = vim.api.nvim_list_bufs()
              local current = vim.api.nvim_get_current_buf()
              local to_remove = {}
              for buf in bufs do
                if buf ~= current then
                  table.insert(to_remove, buf)
                end
              end
              bd(to_remove, false)
            end
          '';
        lua = true;
      }
    ];
  };
}
