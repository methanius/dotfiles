---@type LSPKeymapSpec[]
local M = {
  { "gd",         Snacks.picker.lsp_definitions,       "Goto Definition",                    has = "definition" },
  { "K",          vim.lsp.buf.hover,                   "Show workspace symbol under cursor", has = "hover" },
  { "gr",         Snacks.picker.lsp_references,        "Get references",                     extra_opts = { nowait = true } },
  { "gt",         Snacks.picker.lsp_type_definitions,  "Go to type defition",                "typeDefinition" },
  { "gI",         vim.lsp.buf.implementation,          "Goto Implementation" },
  { "gD",         vim.lsp.buf.declaration,             "Goto Declaration" },
  { "<leader>cc", vim.lsp.codelens.run,                "Run Codelens",                       mode = { "n", "v" },           has = "codeLens" },
  { "<leader>cC", vim.lsp.codelens.refresh,            "Refresh & Display Codelens",         mode = { "n", "v" },           has = "codeLens" },
  { "<F4>",       vim.lsp.buf.code_action,             "Code Actions",                       has = "codeAction" },
  { "<leader>fd", Snacks.picker.diagnostics,           "Diagnostics" },
  { "<leader>fs", Snacks.picker.lsp_symbols,           "(f)ind document (s)ymbols",          has = "documentSymbol" },
  { "<leader>fS", Snacks.picker.lsp_workspace_symbols, "(f)ind workspace (S)ymbols",         has = "workspaceSymbol" },
  {
    "<F2>",
    function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end,
    "Rename symbol under cursor",
    extra_opts = { expr = true },
    has = "rename",
  },
  {
    "<leader>f",
    function() vim.lsp.buf.format({ async = true }) end,
    "Format buffer",
    has = "formatting"
  },
  {
    "<leader>f",
    vim.lsp.buf.format,
    "Format range",
    mode = "v",
    has = { "rangesFormatting", "rangeFormatting" }
  },
  {
    "<C-h>",
    vim.lsp.buf.signature_help,
    "Signature help for symbol under cursor",
    mode = "i",
    has = "signatureHelp",
  },
  -- C++ specific
  {
    "go",
    function()
      vim.cmd("ClangdSwitchSourceHeader")
    end,
    "Switch between header and source (C++ specific)",
    mode = { "n", "v" },
    specific_client = "clangd",
  },
  -- -- Rustaceanvim specific
  -- if client.name == "rust-analyzer" then
  {
    "<leader>mu",
    function()
      vim.cmd.RustLsp({ "moveItem", "up" })
    end,
    "Move item up",
    mode = { "n", "v" },
    specific_client = "rust-analyzer",
  },
  {
    "<leader>md",
    function()
      vim.cmd.RustLsp({ "moveItem", "down" })
    end,
    "Move item down",
    mode = { "n", "v" },
    specific_client = "rust-analyzer",
  },
}

return M
