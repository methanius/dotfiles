local bufnr = vim.api.nvim_get_current_buf()


vim.api.nvim_buf_set_keymap(
  bufnr,
  "n",
  "I",
  'G^wwi',
  { desc = "dap-repl insert at start of input line", noremap = true, silent = true }
)
