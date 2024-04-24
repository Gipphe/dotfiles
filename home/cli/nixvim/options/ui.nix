{
  programs.nixvim.extraConfigLuaPre = ''
    local Ui = {}

    ---@return {fg?:string}?
    function Ui.fg(name)
      local color = Ui.color(name)
      return color and { fg = color } or nil
    end

    ---@param name string
    ---@param bg? boolean
    ---@return string?
    function Ui.color(name, bg)
      ---@type {foreground?:number}?
      ---@diagnostic disable-next-line: deprecated
      local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name, link = false })
        or vim.api.nvim_get_hl_by_name(name, true)
      ---@diagnostic disable-next-line: undefined-field
      ---@type string?
      local color = nil
      if hl then
        if bg then
          color = hl.bg or hl.background
        else
          color = hl.fg or hl.foreground
        end
      end
      return color and string.format("#%06x", color) or nil
    end
  '';
}
