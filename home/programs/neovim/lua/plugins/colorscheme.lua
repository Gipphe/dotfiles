local theme = "catppuccin"
local colorschemes = {
  tokyonight = {
    name = "tokyonight",
    lazy = {
      "folke/tokyonight.nvim",
      lazy = true,
      opts = {
        style = "night",
      },
    },
  },
  catppuccin = {
    name = "catppuccin",
    lazy = {
      "catppuccin/nvim",
      lazy = true,
      name = "catppuccin",
      opts = {
        flavour = "mocha",
        term_colors = true,
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.15,
        },
        integrations = {
          aerial = true,
          alpha = true,
          cmp = true,
          dashboard = true,
          flash = true,
          gitsigns = true,
          headlines = true,
          illuminate = true,
          indent_blankline = { enabled = true },
          leap = true,
          lsp_trouble = true,
          mason = true,
          markdown = true,
          mini = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          navic = { enabled = true, custom_bg = "lualine" },
          neotest = true,
          neotree = true,
          noice = true,
          notify = true,
          semantic_tokens = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
        },
        color_overrides = {
          mocha = {
            surface1 = "#595e73",
          },
        },
      },
    },
  },
}

local selected_theme = colorschemes[theme]

return {
  selected_theme.lazy,
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = selected_theme.name,
    },
  },
}
