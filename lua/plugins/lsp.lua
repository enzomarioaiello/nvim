return {
  -- LSP Configuration
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      -- LSP Support
      "neovim/nvim-lspconfig",
      -- Mason is configured in mason-workaround.lua to pin the version
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      
      -- Completion and Snippets
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()
      
      -- Configure nvim-cmp
      local cmp = require("cmp")
      local cmp_select = {behavior = cmp.SelectBehavior.Select}
      local cmp_mappings = lsp_zero.defaults.cmp_mappings({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({select = true}),
        ["<C-Space>"] = cmp.mapping.complete(),
      })
      
      -- Configure lsp-zero preferences
      lsp_zero.set_preferences({
        sign_icons = {}
      })
      
      -- On LSP attach setup keymaps
      lsp_zero.on_attach(function(client, bufnr)
        local opts = {buffer = bufnr}
        
        -- Default LSP keymaps from lsp-zero
        lsp_zero.default_keymaps(opts)
        
        -- Custom keymaps
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vgu", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-j>", function() vim.lsp.buf.signature_help() end, opts)
      end)
      
      -- Setup Mason with compatibility fixes
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      
      -- Safely setup Mason-lspconfig with a fallback approach if the automatic handlers fail
      local mason_lspconfig = require("mason-lspconfig")
      
      -- Expanded list of servers to install
      local ensure_installed = {
        -- Languages
        "rust_analyzer",      -- Rust
        "lua_ls",             -- Lua
        "ts_ls",           -- TypeScript/JavaScript
        "svelte",             -- Svelte
        "jedi_language_server", -- Python (Jedi)
        "bashls",             -- Bash
        "clangd",             -- C/C++
        "jdtls",              -- Java
        "dockerls",           -- Docker
        "docker_compose_language_service", -- Docker Compose
        "jsonls",             -- JSON
        "yamlls",             -- YAML
        "html",               -- HTML
        "cssls",              -- CSS
        
        -- Linters and formatters (some will be installed via Mason directly)
        "eslint",             -- JavaScript/TypeScript linting
      }
      
      -- First try to set up with the modern approach but in a pcall to catch failures
      local setup_success, _ = pcall(function()
        mason_lspconfig.setup({
          ensure_installed = ensure_installed,
          handlers = {
            -- Default handler
            function(server_name)
              require("lspconfig")[server_name].setup({})
            end,
            
            -- Customized handlers
            ["rust_analyzer"] = function()
              require("lspconfig").rust_analyzer.setup({
                settings = {
                  ["rust-analyzer"] = {
                    checkOnSave = {
                      command = "clippy"
                    },
                    cargo = {
                      loadOutDirFromCheck = true
                    },
                    procMacro = {
                      enable = true
                    }
                  }
                }
              })
            end,
          },
        })
      end)
      
      -- If the modern approach failed, use a more compatible fallback approach
      if not setup_success then
        vim.notify("Using mason-lspconfig fallback approach due to compatibility issues", vim.log.levels.WARN)
        
        -- Basic setup without handlers
        mason_lspconfig.setup({
          ensure_installed = ensure_installed,
        })
        
        -- Manually set up servers
        local lspconfig = require("lspconfig")
        
        -- Default setup for most servers
        local servers = mason_lspconfig.get_installed_servers()
        for _, server in ipairs(servers) do
          if server ~= "rust_analyzer" then -- We'll set up rust_analyzer specially
            lspconfig[server].setup({})
          end
        end
        
        -- Special setup for rust_analyzer
        lspconfig.rust_analyzer.setup({
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy"
              },
              cargo = {
                loadOutDirFromCheck = true
              },
              procMacro = {
                enable = true
              }
            }
          }
        })
      end
      
      -- Also install standalone formatters and linters that aren't part of LSP
      -- Add code to ensure these are installed with mason.nvim
      local mason_registry = require("mason-registry")
      local function ensure_installed_mason(package_names)
        for _, package_name in ipairs(package_names) do
          local package_available, _ = pcall(function() return mason_registry.is_installed(package_name) end)
          if package_available and not mason_registry.is_installed(package_name) then
            vim.cmd("MasonInstall " .. package_name)
          end
        end
      end
      
      -- Schedule this to run after startup to avoid loading issues
      vim.defer_fn(function() 
        ensure_installed_mason({
          "ruff", -- Python linter
          "black", -- Python formatter
          "stylua", -- Lua formatter
          "prettierd", -- JavaScript/TypeScript/HTML/CSS/JSON formatter
          "shfmt", -- Shell formatter
        })
      end, 100)
    end,
  },
  
  -- Rust Tools
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("rust-tools").setup({
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "]e", require("rust-tools").code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      })
    end,
  },
}
