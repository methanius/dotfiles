local augroup = vim.api.nvim_create_augroup
local FileGroup = augroup("FileGroup", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

local function mergeBintoA(a, b)
  for k, v in pairs(b) do
    a[k] = v
  end
  return a
end

local ClausGroup = augroup("Claus", {})

-- All files
autocmd(
  "FileType",
  { desc = "Open files at last edited position", group = FileGroup, pattern = "*", command = 'silent! normal! g`"zv' }
)

autocmd("LspAttach", {
  group = ClausGroup,
  callback = function(args)
    local opts = { buffer = args.buf }
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, mergeBintoA(opts, { desc = "Show LPS workspace symbol under cursor" }))

    vim.keymap.set({ "n", "v" }, "<F4>", vim.lsp.buf.code_action, mergeBintoA(opts, { desc = "LSP code action" }))

    vim.keymap.set("n", "<F2>", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, mergeBintoA(opts, { desc = "LSP rename symbol under cursor", expr = true, }))

    -- Format using LSP
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf(), async = true })
      end,
      mergeBintoA(opts, { desc = "LSP format buffer" }))

    -- Signature help is awesome
    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, mergeBintoA(opts, { desc = "LSP signature help for symbol under cursor" }))

    -- Clangd specific settings
    if client ~= nil and client.name == "clangd" and client.server_capabilities then
      vim.keymap.set({ "n", "v" }, "go", function()
        vim.cmd("ClangdSwitchSourceHeader")
      end, { desc = "Switch between header and source (C++ specific)" })
    end

    if client ~= nil and client.name == "pylsp" and client.server_capabilities then
      client.server_capabilities.documentFormattingProvider = false
    end
    -- Rustaceanvim specific
    if client ~= nil and client.name == "rust-analyzer" and client.server_capabilities then
      print("Attached to rust file")
      vim.keymap.set("n", "<leader>mu", function()
        vim.cmd.RustLsp({ "moveItem", "up" })
      end, mergeBintoA(opts, { desc = "Move item up" }))
      vim.keymap.set("n", "<leader>md", function()
        vim.cmd.RustLsp({ "moveItem", "down" })
      end, mergeBintoA(opts, { desc = "Move item down" }))
    end

    if client ~= nil and client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, args.buf)
    end
  end,
})
