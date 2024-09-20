return {
  "L3MON4D3/LuaSnip", -- Snippet engine
  dependencies = {},
  build = "make install_jsregexp",
  event = "VeryLazy",
  config = function()
    local luasnip = require("luasnip")
    luasnip.config.set_config({
      -- Allow jump back to snippet even if exited
      keep_roots = true,
      link_roots = true,
      link_children = true,

      -- Good setting for dynamic snippets to change while typing
      update_events = "TextChanged,TextChangedI",
    })
    require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/luasnippets" } })
  end,
}
