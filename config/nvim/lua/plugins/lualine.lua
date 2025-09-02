return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {},
    config = true,
    opts = function()
      local clients_lsp = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        if clients == nil then
          return ""
        end
        local c = {}
        for _, client in pairs(clients) do
          table.insert(c, client.name)
        end
        return "\u{f085} " .. table.concat(c, "|")
      end


      return {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch" },
            { "diff" },
            { "diagnostics" },
          },
          lualine_c = {
            {
              "filename",
              path = 0,
            },
            {},
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = {},
          lualine_z = { clients_lsp },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "mason", "lazy", "oil", "fugitive" },
      }
    end,
  },
}
