
-- I like <space>, haven't tried others
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- I usually prefer 4 spaces indentation
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Show line relative numbers initially
-- I use Snacks to toggle if I want
vim.o.number = true
vim.o.relativenumber = true

-- Save undo history, I really enjoy persistent undo history
vim.o.undofile = true

-- Synx Neovim and system clipboard, I've never used yank rings anyway
vim.o.clipboard = "unnamedplus"

-- Use rounded borders for floating windows.
vim.o.winborder = 'rounded'

-- Case insensitive searching UNLESS /C or the search has capitals.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Smartindentation for use with "=". I actually override this with Treesitter
vim.o.smartindent = true

-- I strongly dislike line-wrapping!
vim.o.wrap = false

-- Swapfiles have usually given me more grief than good
vim.o.swapfile = false

-- Do not keep previous search highlighted
vim.o.hlsearch = false

-- Show where the current search mathces
vim.o.incsearch = true

-- Limit for how many lines to scroll off the screen. Extremely appreciated!
vim.o.scrolloff = 8

-- I enjoy the column with mini gitgutter
vim.wo.signcolumn = "yes"

-- Add support for - in filenames
vim.opt.isfname:append("@-@")

vim.o.updatetime = 50

-- Set 󰌑 as icon for line breaks
vim.o.list = true
vim.opt.listchars = {
  trail = '⋅',
}
--
-- Disable cursor blinking in terminal mode.
vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor'

-- I don't want "[written]" and "SEARCH HIT BOTTOM" messages
vim.opt.shortmess:append {
    w = true,
    s = true,
}
