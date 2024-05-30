vim.g.mapleader = " "
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines 1 line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines 1 line up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Append line below to current line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half buffer down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half buffer up and center cursor" })
vim.keymap.set(
  "n",
  "n",
  "nzzzv",
  { desc = "Next item matching search, including in folds, keeping cursor centered in buffer" }
)
vim.keymap.set(
  "n",
  "N",
  "Nzzzv",
  { desc = "Prev item matchin search, including in folds, keeping cursor centered in buffer" }
)

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank selection to system register" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system register" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

vim.keymap.set("n", "Q", "<nop>", { desc = "I will never need Ex mode, so remove it." })

vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Go to prev item in the quickfix list and center cursor" })
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Go to next item in the quickfix list and center cursor" })
vim.keymap.set(
  "n",
  "<leader>k",
  "<cmd>lnext<CR>zz",
  { desc = "Go to next item in the file local quickfist list and center cursor" }
)
vim.keymap.set(
  "n",
  "<leader>j",
  "<cmd>lprev<CR>zz",
  { desc = "Go to prev item in the file local quickfist list and center cursor" }
)

vim.keymap.set(
  "n",
  "<leader>sr",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Regex find replace word under cursor" }
)
vim.keymap.set(
  "n",
  "<leader>x",
  "<cmd>!chmod +x %<CR>",
  { silent = true, desc = "Make current file executable (if on Linux)" }
)

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end, { desc = "Shout out current file" })
