return {
  {
    "mason-org/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonLog",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonUpdate",
    },
    opts = {
      pip = { upgrade_pip = true },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      { "smjonas/inc-rename.nvim", opts = {}, },
    },
    config = function()
      local servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  enabled = false,
                },
                pyflakes = {
                  enabled = false,
                },
                mccabe = {
                  enabled = false,
                },
                autopep8 = {
                  enabled = false,
                },
                yapf = {
                  enabled = false,
                },
                ruff = {
                  enabled = false,
                  formatEnabled = true,
                  preview = true,
                },
                pylsp_mypy = {
                  live_mode = true,
                },
              },
            },
          },
        },
        bashls = {},
        clangd = {},
        ruff = {},
        lua_ls = {},
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_installation = true,
        automatic_enable = true,
      })

      for server, settings in pairs(servers) do
        vim.lsp.config(server, settings)
        -- enable is handled by mason-lspconfig for now
        -- vim.lsp.enable(server)
      end
    end,
  },
}
