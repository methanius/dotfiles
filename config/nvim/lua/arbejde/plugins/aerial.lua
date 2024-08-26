return {
  "stevearc/aerial.nvim",
  opts = {
    layout = {
      default_direction = "prefer_right",
    },
    on_attach = function(bufnr)
      -- From the docs, jump back and forth with {}
      vim.keymap.set(
        "n",
        "{",
        "<Cmd>AerialPrev<CR>",
        { buffer = bufnr, desc = "Jump to previous LSP symbol using Aerial" }
      )
      vim.keymap.set("n", "}", "<Cmd>AerialNext<CR>", { buffer = bufnr, desc = "Jump to next LSP symbol using Aerial" })
    end,
  },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>fs",
      mode = "n",
      "<Cmd>AerialToggle!<Cr>",
      desc = "Toggle Aerial symbol walker",
    },
  },
}
