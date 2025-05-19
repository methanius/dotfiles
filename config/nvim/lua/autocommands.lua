local FileGroup = vim.api.nvim_create_augroup("FileGroup", { clear = true })

-- All files
vim.api.nvim_create_autocmd(
  "FileType",
  { desc = "Open files at last edited position", group = FileGroup, pattern = "*", command = 'silent! normal! g`"zv' }
)
