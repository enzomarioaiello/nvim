-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.6',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use ('nvim-treesitter/playground')
  use { "ellisonleao/gruvbox.nvim" } -- Colorscheme
  use { "nvim-lua/plenary.nvim" }
  use { "/mbbill/undotree" }
  use { "tpope/vim-fugitive" }
  -- use {'edluffy/hologram.nvim'} -- PDF Viewer
  -- nvim v0.7.2
  use({
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    requires = {
        "nvim-lua/plenary.nvim",
    },
})

    use {
      "nvim-neotest/neotest",
      requires = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter"
      }
    }

  use {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      requires = { {"nvim-lua/plenary.nvim"} }
  }

  use {
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
              log_level = "info", -- set to "off" to disable logging completely
              disable_inline_completion = false, -- disables inline completion for use with cmp
              disable_keymaps = false, -- disables built in keymaps for more manual control
              condition = function()
                return false
              end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
            })
      end,
  }

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v3.x',
	  requires = {
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  {'neovim/nvim-lspconfig'},
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'L3MON4D3/LuaSnip'},
	  }
  }
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
      require("toggleterm").setup()
  end}
  -- use {"github/copilot.vim"}
  use { "scottmckendry/cyberdream.nvim" }
  use { "xiyaowong/transparent.nvim" }
  use { 'karb94/neoscroll.nvim' }

  -- TESTING
    use {
        "rcasia/neotest-java",
        ft = "java",
        requires = {
          "mfussenegger/nvim-jdtls",          -- LSP for Java
          "mfussenegger/nvim-dap",            -- Debug Adapter Protocol for Java
          "rcarriga/nvim-dap-ui",             -- UI for nvim-dap
          "theHamsta/nvim-dap-virtual-text"   -- virtual text for nvim-dap
        }
      }
   use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      require('neotest').setup({
        adapters = {
          ["neotest-java"] = {
            -- Add any specific configuration here
          },
        },
      })
    end,
  }
end)
