return {
  {
    "echasnovski/mini.surround",
    event = { "InsertEnter", "CmdlineEnter" , "ModeChanged *:[vV\x16]*"},
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highligt = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  -- setup mini.diff
  {
    "echasnovski/mini.diff",
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
    },
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
}
