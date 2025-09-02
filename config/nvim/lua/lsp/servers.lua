--- I use lspconfig, so these are just the overrides
---@type table<string, vim.lsp.Config>
local M = {
  bashls = {},
  clangd = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        codeLens = {
          enable = true,
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "All",
          semicolon = "All",
          arrayIndex = "SameLine",
        },
        diagnostics = {
          globals = {
            "s", "c", "t", "sn", "i", "fmt", "k", "rep", "ai",
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
    settings = {
      ty = {
        diagnosticMode = "workspace",
        experimental = {
          rename = true,
          autoImport = true,
        },
      },
    },
    single_file_support = true,
  },
}

return M
