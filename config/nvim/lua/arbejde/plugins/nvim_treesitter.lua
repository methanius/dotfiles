return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "vim",
          "vimdoc",
          "cpp",
          "python",
          "bash",
          "markdown",
          "lua",
          "cmake",
          "gitignore",
          "latex",
          "yaml",
          "toml",
          "rust",
          "haskell",
        },
        sync_install = false,
        ignore_install = {},
        highlight = { enable = true },
        auto_install = false,
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },
}
