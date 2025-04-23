-- Show diagnostics in floating windows
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics in a floating window" })

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({count=-1, float=true})
end, { desc = "Go to previous LSP diagnostic" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({count=1, float=true})
end, { desc = "Go to next LSP diagnostic" })

vim.diagnostic.config({
  update_in_insert = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  virtual_text = true,
})
