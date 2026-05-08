--- I use lspconfig, so these are just the overrides

--- Build a `cmd` for tools we launch via `uvx`. Always passes `--offline` so
--- nvim startup never blocks on a network round-trip; uv serves from its
--- cache. To pick up a new upstream release, refresh the cache out-of-band:
---   uvx ruff --version    (fetches latest, populates cache)
---   uvx ty --version
--- After that the next nvim session will use the refreshed binary.
---@param tool string  Tool name as known to uv (e.g. "ruff", "ty")
---@param ... string   Extra args appended after the tool name (e.g. "server")
---@return string[]
local function uvx_cmd(tool, ...)
  local cmd = { "uvx", "--offline", tool }
  vim.list_extend(cmd, { ... })
  return cmd
end

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
  ruff = {
    cmd = uvx_cmd("ruff", "server"),
  },
  tombi = {},
  ty = {
    cmd = uvx_cmd("ty", "server"),
    filetypes = { "python" },
    root_dir = vim.fs.root(0, { ".git/", "pyproject.toml", "ty.toml" }),
    settings = {
      ty = {
        diagnosticMode = "workspace",
        completions = {
          autoImport = true,
        },
      },
    },
    single_file_support = true,
  },
}

return M
