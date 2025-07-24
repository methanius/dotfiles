return {
  {
    "nvim-mini/mini.icons",
    opts = {},
    config = function ()
      require("mini.icons").setup(opts)
      MiniIcons.mock_nvim_web_devicons()
    end
  },
  {
    "nvim-mini/mini.surround",
    event = { "InsertEnter", "CmdlineEnter", "ModeChanged *:[vV\x16]*" },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  -- setup mini.diff
  {
    "nvim-mini/mini.diff",
    opts = {
      view = {
        style = "sign",
        signs = {
          add = "▎",
          change = "▎",
          delete = "",
        },
      }
    },
  },

  -- lualine integration
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local x = opts.sections.lualine_x
      for _, comp in ipairs(x) do
        if comp[1] == "diff" then
          comp.source = function()
            local summary = vim.b.minidiff_summary
            return summary
                and {
                  added = summary.add,
                  modified = summary.change,
                  removed = summary.delete,
                }
          end
          break
        end
      end
    end,
  },
  {
    "nvim-mini/mini.ai",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    ecent = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          -- Completely stealing these from LazyVim and treesitter-textobjects
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        }
      }
    end,
  },
}
