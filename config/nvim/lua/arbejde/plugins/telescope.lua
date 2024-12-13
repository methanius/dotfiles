return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-tree/nvim-web-devicons",              opts = true },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "benfowler/telescope-luasnip.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function(opts)
    local telescope = require("telescope")
    telescope.setup({ opts })
    telescope.load_extension("fzf")
    telescope.load_extension("luasnip")
  end,
  opts = {
    defaults = {
      path_display = {
        truncate = 4,
      },
    },
    extensions = {
      fzf = {}
    },
  },
  --Set keymaps
  keys = {
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Fuzzy find files in cwd with telescope",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").git_files()
      end,
      desc = "Fuzzy find files in cwd under git revision with telescope",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Search for word under cursor via ripgrep",
    },
    {
      "<leader>fl",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep with telescope",
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume latest Telescope search",
    },
    {
      "gr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "Find all LSP references to word under cursor in telescope",
    },
    {
      "gd",
      function()
        require("telescope.builtin").lsp_definitions()
      end,
      desc = "Go to definition or open list of definitions of word under cursoer in telescope",
    },
    {
      "<leader>fd",
      function()
        require("telescope.builtin").diagnostics({ bufnr = 0 })
      end,
      desc = "Find diagnostics using telescope",
    },
    {
      "gt",
      function()
        require("telescope.builtin").lsp_type_definitions()
      end,
      desc = "Go to type definition of word under cursor if there's only one, otherwise show options in Telescope",
    },
    {
      "<leader>gf",
      require("telescope.builtin").git_bcommits,
      desc = "Git file commits with Telescope",
    },
  },
}
