return {
  {
    "scalameta/nvim-metals",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local config = require('metals').bare_config()
      local gradleScript = os.getenv('GRADLE_SCRIPT')
      config.find_root_dir_max_project_nesting = 3
      config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javads1", "com.github.swagger.akka.javads1" },
      }
      if (gradleScript ~= nil) then
        config.settings.gradleScript = gradleScript
      end

      config.init_options.statusBarProvider = 'on'
      config.capabilities = require('cmp_nvim_lsp').default_capabilities()
      return config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group
      })
    end,
  },
}
