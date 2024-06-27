{ lib, ... }:
{
  programs.nixvim.extraConfigLuaPre = lib.mkBefore ''
    vim.uv = vim.uv or vim.loop

    local Util = {}

    ---@return string
    function Util.norm(path)
      if path:sub(1, 1) == "~" then
        local home = vim.uv.os_homedir()
        if home:sub(-1) == "\\" or home:sub(-1) == "/" then
          home = home:sub(1, -2)
        end
        path = home .. path:sub(2)
      end
      path = path:gsub("\\", "/"):gsub("/+", "/")
      return path:sub(-1) == "/" and path:sub(1, -2) or path
    end

    function Util.is_win()
      return vim.uv.os_uname().sysname:find("Windows") ~= nil
    end
  '';
}
