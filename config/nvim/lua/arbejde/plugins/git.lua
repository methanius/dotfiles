return {
  {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
      {
        "<leader>gs",
        vim.cmd.Git,
        desc = "Toggle Fugitive",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({
        on_attach = function()
          vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview git hunk" })
          vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage git hunk" })
          vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset git hunk" })
          vim.keymap.set("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage git hunk"})
          vim.keymap.set("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset git hunk"})
          vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer to git"})
          vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage git hunk"})
          vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git reset entire buffer"})
          vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview git hunk"})
          vim.keymap.set("n", "<leader>gb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Git blame line" })
          vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle git blame line"})
          vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { desc = "Git diff this"})
          vim.keymap.set("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end, { desc = "Git diff all"})
          vim.keymap.set("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Gitsigns toggle deleted"})
        end,
      })
    end,
  },
}
