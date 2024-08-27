return {
  {
    "williamboman/mason.nvim",
    opts = {
      pip = { upgrade_pip = true },
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "p00f/clangd_extensions.nvim",
      "ckipp01/stylua-nvim",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip", -- Snippet engine
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path", -- source for local filesystem paths
      "onsails/lspkind.nvim",
      {
        "ckipp01/stylua-nvim",
        build = "cargo install stylua; cargo install stylua --features lua52; cargo install stylua --features lua53; cargo install stylua --features lua54; cargo install stylua --features luau;",
      },
      {
        "j-hui/fidget.nvim",
        config = true,
      },
    },
    config = function()
      local handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
        ["pylsp"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.pylsp.setup({
            settings = {
              pylsp = {
                plugins = {
                  ruff = {
                    enabled = true,
                    formatEnabled = true,
                    preview = true,
                  },
                  pylsp_mypy = {
                    live_mode = true,
                  },
                },
              },
            },
          })
        end,
      }
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = { "bashls", "clangd", "pylsp", "taplo", "neocmake", "lua_ls" },
        handlers = handlers,
      })

      -- Futhark filetype and lsp
      vim.filetype.add({
        extension = {
          fut = "futhark",
          futhark = "futhark",
        },
      })
      require("lspconfig").futhark_lsp.setup({})

      -- Change border of documentation hover window
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      -- Border around signature help
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      -- Border around :LspInfo
      require("lspconfig.ui.windows").default_options.border = "single"

      local luasnip = require("luasnip")

      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        -- I like the bordered look for now ;)
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP
          { name = "luasnip" }, -- luasnip snippets
          { name = "path" }, -- filesystem paths
        }),
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item(cmp_select)
            else
              cmp.complete()
            end
          end),
          ["<C-p>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item(cmp_select)
            else
              cmp.complete()
            end
          end),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp.mapping(function()
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-b>"] = cmp.mapping(function()
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        },
        formatting = {
          format = require("lspkind").cmp_format({}),
        },
      })
    end,
  },
}
