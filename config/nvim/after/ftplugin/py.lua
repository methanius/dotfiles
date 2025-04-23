vim.opt_local.shiftwidth = 4
vim.keymap.set(
  { "n", "i" },
  "<F5>",
  "<Cmd>w <bar> exec '!python '.shellescape('%')<CR>",
  { desc = "Save and run Python file" }
)
