--- I use lspconfig, so these are just the overrides

--- Builds a `cmd` for tools we launch via `uvx`. Probes pypi.org once at
--- module load (~1s curl with --max-time 1) and bakes the result into a
--- list-of-strings. If offline, falls back to `uvx --offline ...` so a warm
--- uv cache still serves the LSP. Cost: one probe per nvim session.
---
--- (Earlier attempt used a Lua function for `cmd` -- that signature in
--- nvim's native LSP API is `fun(dispatchers, config) -> rpc_client`, not
--- `fun() -> string[]`, which crashed initialization with
--- `attempt to call field 'request' (a nil value)`.)
---@param tool string  Tool name as known to uv (e.g. "ruff", "ty")
---@param ... string   Extra args appended after the tool name (e.g. "server")
---@return string[]
local function uvx_cmd(tool, ...)
  vim.fn.system({ "curl", "-fsS", "--max-time", "1", "https://pypi.org/simple/" })
  local online = vim.v.shell_error == 0
  local cmd = online and { "uvx", tool } or { "uvx", "--offline", tool }
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
