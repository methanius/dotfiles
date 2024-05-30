return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,

          -- Automagically jump forward to matching textobjects
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
            ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
            ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

            ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
            ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

            ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
            ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]="] = { query = "@assignment.inner", desc = "Next assignment inner" },
            ["]a"] = { query = "@parameter.outer", desc = "Next parameter outer" },
            ["]i"] = { query = "@conditional.outer", desc = "Next conditional outer" },
            ["]l"] = { query = "@loop.outer", desc = "Next loop outer" },
            ["]f"] = { query = "@call.outer", desc = "Next function call outer" },
            ["]m"] = { query = "@function.outer", desc = "Next function body outer" },
            ["]c"] = { query = "@class.outer", desc = "Next class body outer" },
          },
          goto_previous_start = {
            ["[="] = { query = "@assignment.inner", desc = "Next assignment inner" },
            ["[a"] = { query = "@parameter.outer", desc = "Next parameter outer" },
            ["[i"] = { query = "@conditional.outer", desc = "Next conditional outer" },
            ["[l"] = { query = "@loop.outer", desc = "Next loop outer" },
            ["[f"] = { query = "@call.outer", desc = "Next function call outer" },
            ["[m"] = { query = "@function.outer", desc = "Next function body outer" },
            ["[c"] = { query = "@class.outer", desc = "Next class body outer" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sp"] = { query = "@parameter.inner", desc = "Swap next parameter" },
            ["<leader>sa"] = { query = "@argument.inner", desc = "Swap next argument" },
          },
          swap_previous = {
            ["<leader>sP"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
            ["<leader>sA"] = { query = "@argument.inner", desc = "Swap previous argument" },
          },
        },
      },
    })
  end,
}
