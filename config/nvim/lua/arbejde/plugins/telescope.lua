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
      require("telescope.builtin").find_files,
      desc = "Fuzzy find files in cwd with telescope",
    },
    {
      "<leader>fg",
      require("telescope.builtin").git_files,
      desc = "Fuzzy find files in cwd under git revision with telescope",
    },
    {
      "<leader>fw",
      require("telescope.builtin").grep_string,
      desc = "Search for word under cursor via ripgrep",
    },
    {
      "<leader>fl",
      require("telescope.builtin").live_grep,
      desc = "Live grep with telescope",
    },
    {
      "<leader>fa",
      require("telescope.builtin").resume,
      desc = "Resume latest Telescope search",
    },
    {
      "gr",
      function()
        require("telescope.builtin").lsp_references({theme = "ivy"})
      end,
      desc = "Find all LSP references to word under cursor in telescope",
    },
    {
      "gd",
      require("telescope.builtin").lsp_definitions,
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
      require("telescope.builtin").lsp_type_definitions,
      desc = "Go to type definition of word under cursor if there's only one, otherwise show options in Telescope",
    },
    {
      "<leader>gf",
      require("telescope.builtin").git_bcommits,
      desc = "Git file commits with Telescope",
    },
  },
}
