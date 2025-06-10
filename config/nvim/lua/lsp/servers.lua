---@type lsp.ClientCapabilities
local ty_capabilities = vim.lsp.protocol.make_client_capabilities()
ty_capabilities.textDocument.hover = nil

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
  ty = {
    cmd = { "uvx", "ty", "server" },
    filetypes = { "python" },
    root_dir = vim.fs.root(0, { ".git/", "pyproject.toml", "ty.toml" }),
    -- init_options = {
    --   settings = {
    --     experimental = {
    --       completions = {
    --         enable = true,
    --       },
    --     },
    --   },
    -- },
    single_file_support = true,
    capabilities = ty_capabilities,
  },
}

return M
