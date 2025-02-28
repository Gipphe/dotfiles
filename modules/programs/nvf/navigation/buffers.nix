let
  inherit (import ../mapping-prefixes.nix) buffer;
  del_buffer_with_confirmation = # lua
    ''
      function(bufnum)
        local del = require('bufdelete').bufdelete
        local is_modified = vim.api.nvim_buf_get_option(bufnum, "modified")
        if is_modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.api.nvim_buf_get_name(bufnum)), "&Yes\n&No\n&Cancel")
          if choice == 1 then
            vim.cmd.write()
            del(bufnum)
          elseif choice == 2 then
            del(bufnum, true)
          end
        else
          del(bufnum)
        end
      end
    '';
in
{
  imports = [ ./bufferline.nix ];
  programs.nvf.settings.vim = {
    tabline.nvimBufferline = {
      enable = true;
      mappings = {
        closeCurrent = "<leader>bd";
      };
      setupOpts.options = {
        close_command = # lua
          ''
            function()
              local bd = ${del_buffer_with_confirmation}
              bd(nvim_get_current_buf())
            end
          '';

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
              local bd = ${del_buffer_with_confirmation}
              local bufs = vim.api.nvim_list_bufs()
              local current = vim.api.nvim_get_current_buf()
              local to_remove = {}
              for _, buf in pairs(bufs) do
                if buf ~= current then
                  table.insert(to_remove, buf)
                end
              end

              for _, buf in pairs(to_remove) do
                bd(buf)
              end
            end
          '';
        lua = true;
      }
    ];
  };
}
