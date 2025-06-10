--- I use lspconfig, so these are just the overrides
---@type table<string, vim.lsp.Config>
local M = {
  bashls = {},
  clangd = {},
  lua_ls = {},
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
  ruff = {},
}

return M
