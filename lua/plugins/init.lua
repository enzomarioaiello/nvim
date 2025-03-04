return {
  -- Lazy.nvim
  {
    "folke/lazy.nvim",
    version = "*",
  },

  -- Colorschemes
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000,
  },
  {
    "xiyaowong/transparent.nvim",
    priority = 1000,
  },

  -- LSP and Completion
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("plugins.lsp")
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
            -- Hover actions
            -- vim.keymap.set("n", "<C-space>", require("rust-tools").hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "]e", require("rust-tools").code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "java" },
        auto_install = true,
        highlight = { enable = true },
      })
    end,
  },
  {
    "nvim-treesitter/playground",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.telescope")
    end,
  },

  -- Git
  {
    "tpope/vim-fugitive",
    config = function()
      require("plugins.fugitive")
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.lazygit")
    end,
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.harpoon")
    end,
  },

  -- Terminal
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  -- {
  --   "akinsho/toggleterm.nvim",
  --   tag = "*",
  --   config = function()
  --     require("plugins.toggleterm")
  --   end,
  -- },

  -- Undo Tree
  {
    "mbbill/undotree",
    config = function()
      require("plugins.undotree")
    end,
  },

  -- Neoscroll
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("plugins.neoscroll")
    end,
  },

  -- Testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcasia/neotest-java",
    },
    ft = { "java" },
    config = function()
      require("plugins.neotest")
    end,
  },

  -- Java Development
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("plugins.jdtls")
    end,
  },

  -- Supermaven
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-k>",
        },
        ignore_filetypes = { cpp = true },
        color = {
          suggestion_color = "#a05da2",
          cterm = 10,
        },
        log_level = "info",
        disable_inline_completion = false,
        disable_keymaps = false,
        condition = function()
          return false
        end,
      })
    end,
  },
} 
