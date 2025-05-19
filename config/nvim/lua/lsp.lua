local M = {}

-- I only ever use inlay hints in Rust an a few other languages
-- Toggler from Snacks is configured
vim.g.inlay_hints = false

--- Set up LSP keymaps and autocommands for the given buffer
--- Stolen and modified from MariaSolOs' dotfiles on github
--- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/lsp.lua
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  ---@param lhs string
  ---@param rhs string|function
  ---@param desc string
  ---@param mode? string|string[]
  ---@param extra_opts? vim.keymap.set.Opts
  local function keymap(lhs, rhs, desc, mode, extra_opts)
    mode = mode or "n"
    local opts = { buffer = bufnr, desc = "LSP: " .. desc }
    if extra_opts then
      opts = vim.tbl_extend("keep", opts, extra_opts)
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  if client.server_capabilities.hoverProvider then
    keymap("K", vim.lsp.buf.hover, "Show workspace symbol under cursor")
  end

  if client.server_capabilities.codeActionProvider then
    keymap("<F4>", vim.lsp.buf.code_action, "Code Actions")
  end

  if client.server_capabilities.renameProvider then
    keymap("<F2>", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end,
      "Rename symbol under cursor",
      "n",
      { expr = true }
    )
  end

  if client.server_capabilities.documentFormattingProvider then
    keymap("<leader>f", function()
      vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf(), async = true })
    end, "Format buffer", "n")
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    keymap("<leader>f", function()
      vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf(), async = true })
    end, "Format range", "v")
  end


  -- Signature help is awesome
  if client.server_capabilities.signatureHelpProvider then
    keymap("<C-h>",
      vim.lsp.buf.signature_help,
      "Signature help for symbol under cursor", "i"
    )
  end

  -- Clangd specific settings
  if client.name == "clangd" then
    keymap("go", function()
      vim.cmd("ClangdSwitchSourceHeader")
    end, "Switch between header and source (C++ specific)", { "n", "v" })
  end

  if client.name == "pylsp" then
    client.server_capabilities.documentFormattingProvider = false
  end
  -- Rustaceanvim specific
  if client.name == "rust-analyzer" then
    keymap("<leader>mu", function()
      vim.cmd.RustLsp({ "moveItem", "up" })
    end, "Move item up")
    keymap("<leader>md", function()
      vim.cmd.RustLsp({ "moveItem", "down" })
    end, "Move item down")
  end

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  vim.lsp.document_color.enable(true, bufnr)

  if client.server_capabilities.referencesProvider then
    keymap("gr", Snacks.picker.lsp_references, "Get references", "n",
      { nowait = true })
  end

  if client.server_capabilities.definitionProvider then
    keymap("gd", Snacks.picker.lsp_definitions, "Goto Definition")
  end

  keymap("<leader>fd", Snacks.picker.diagnostics, "Diagnostics")

  if client.server_capabilities.typeDefinitionProvider then
    keymap("gt", Snacks.picker.lsp_type_definitions, "Go to type defition")
  end

  if client.server_capabilities.documentSymbolProvider then
    keymap("<leader>fs", Snacks.picker.lsp_symbols, "(f)ind document (s)ymbols")
  end

  if client.server_capabilities.workspaceSymbolProvider then
    keymap("<leader>fS", Snacks.picker.lsp_workspace_symbols, "(f)ind workspace (S)ymbols")
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      vim.error("I don't think this should ever be able to happen!")
      return
    end

    on_attach(client, args.buf)
  end,
})
return M
