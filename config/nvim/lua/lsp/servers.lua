--- I use lspconfig, so these are just the overrides
local M = {
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

return M
