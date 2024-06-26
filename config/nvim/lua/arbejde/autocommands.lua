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

--Python specific binds
autocmd("FileType", {
  desc = "Set Python specific keybinds and options",
  pattern = "python",
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set(
      "n",
      "<F5>",
      ":w <bar> exec '!python '.shellescape('%')<CR>",
      mergeBintoA(opts, { desc = "Save and run Python file" })
    )
    vim.keymap.set(
      "i",
      "<F5>",
      "<esc> :w <bar> exec '!python '.shellescape('%')<CR>",
      mergeBintoA(opts, { desc = "Save and run Python file" })
    )
  end,
})

autocmd("LspAttach", {
  group = ClausGroup,
  callback = function(args)
    local opts = { buffer = args.buf }
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, mergeBintoA(opts, { desc = "Show LPS workspace symbol under cursor" }))

    -- Ensure jedi_language_server can refactor in visual and operator mode
    vim.keymap.set({ "n", "v", "o" }, "<F4>", function()
      vim.lsp.buf.code_action()
    end, mergeBintoA(opts, { desc = "LSP code action" }))

    vim.keymap.set("n", "<F2>", function()
      vim.lsp.buf.rename()
    end, mergeBintoA(opts, { desc = "LSP rename symbol under cursor" }))

    -- Format using LSP
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, mergeBintoA(opts, { desc = "LSP format buffer" }))

    -- Signature help is awesome
    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, mergeBintoA(opts, { desc = "LSP signature help for symbol under cursor" }))

    -- Lua ls specific settings
    if client ~= nil and client.name == "lua_ls" and client.server_capabilities then
      vim.keymap.set("n", "<leader>f", function()
        require("stylua-nvim").format_file()
      end, mergeBintoA(opts, { desc = "Format lua using Stylua" }))
    end

    -- Clangd specific settings
    if client ~= nil and client.name == "clangd" and client.server_capabilities then
      vim.keymap.set({ "n", "v" }, "go", function()
        vim.cmd("ClangdSwitchSourceHeader")
      end, { desc = "Switch between header and source (C++ specific)" })
      require("clangd_extensions.inlay_hints").setup_autocmd()
      require("clangd_extensions.inlay_hints").set_inlay_hints()
    end

    -- Ruff_lsp settings
    if client ~= nil and client.name == "ruff" and client.server_capabilities then
      client.server_capabilities.hoverProvider = false
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
  end,
})
