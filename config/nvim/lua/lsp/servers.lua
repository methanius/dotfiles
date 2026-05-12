--- I use lspconfig, so these are just the overrides

--- Build a `cmd` for tools we launch via `uvx`. Always online -- if you're
--- working offline and have the tool cached, hand-patch this to add
--- `--offline` for the session.
---@param tool string  Tool name as known to uv (e.g. "ruff", "ty")
---@param ... string   Extra args appended after the tool name (e.g. "server")
---@return string[]
local function uvx_cmd(tool, ...)
  local cmd = { "uvx", tool }
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
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  },
  tombi = {},
  ty = {
    cmd = uvx_cmd("ty", "server"),
    filetypes = { "python" },
    root_markers = { ".git", "pyproject.toml", "ty.toml" },
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
