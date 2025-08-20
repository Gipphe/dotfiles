return {
  filetypes = vim.tbl_deep_extend('force', require('lspconfig.configs.tailwindcss').default_config.filetypes, { 'elm' }),
  settings = {
    tailwindCSS = {
      includeLanguages = {
        elm = 'html',
      },
      experimental = {
        classRegex = {
          { [[\bclass[\s(<|]+"([^"]*)"]] },
          { [[\bclass[\s(]+"[^"]*"\s+"([^"]*)"]] },
          { [[\bclass[\s<|]+"[^"]*"\s*\+{2}\s*" ([^"]*)"]] },
          { [[\bclass[\s<|]+"[^"]*"\s*\+{2}\s*" [^"]*"\s*\+{2}\s*" ([^"]*)"]] },
          { [[\bclass[\s<|]+"[^"]*"\s*\+{2}\s*" [^"]*"\s*\+{2}\s*" [^"]*"\s*\+{2}\s*" ([^"]*)"]] },
          { [[\bclassList[\s\[\(]+"([^"]*)"]] },
          { [[\bclassList[\s\[\(]+"[^"]*",\s[^\)]+\)[\s\[\(,]+"([^"]*)"]] },
          { [[\bclassList[\s\[\(]+"[^"]*",\s[^\)]+\)[\s\[\(,]+"[^"]*",\s[^\)]+\)[\s\[\(,]+"([^"]*)"]] },
        },
      },
    },
  },
}
