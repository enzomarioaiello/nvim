#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define paths
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${YELLOW}Starting Neovim configuration setup...${NC}"

# Create backup of existing configuration
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo -e "${YELLOW}Creating backup of existing Neovim configuration to ${BACKUP_DIR}...${NC}"
    mkdir -p "$BACKUP_DIR"
    cp -r "$NVIM_CONFIG_DIR"/* "$BACKUP_DIR"/ 2>/dev/null || true
    echo -e "${GREEN}Backup complete!${NC}"

    # Remove existing configuration
    echo -e "${YELLOW}Removing existing Neovim configuration...${NC}"
    rm -rf "$NVIM_CONFIG_DIR"
fi

# Create new directory structure
echo -e "${YELLOW}Creating new Neovim configuration directory structure...${NC}"
mkdir -p "$NVIM_CONFIG_DIR"/{lua/{core,plugins,themes,utils},after/ftplugin}

# Create init.lua
cat >"$NVIM_CONFIG_DIR/init.lua" <<'EOL'
-- Entry point for Neovim configuration
-- Set leader key before loading any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configurations
require("core")
EOL

# Create core/init.lua
cat >"$NVIM_CONFIG_DIR/lua/core/init.lua" <<'EOL'
-- Core configuration loader
require("core.options")
require("core.keymaps")
require("core.lazy") -- Load lazy.nvim plugin manager
require("core.autocmds")
EOL

# Create core/options.lua
cat >"$NVIM_CONFIG_DIR/lua/core/options.lua" <<'EOL'
-- Global Neovim options

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Line wrapping
vim.opt.wrap = false

-- Backup and swap files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Colors
vim.opt.termguicolors = true

-- Scrolling and cursor
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Performance
vim.opt.updatetime = 50

-- Shada file settings
vim.opt.shada = "!,'1000,<50,s10,h"
vim.opt.shadafile = vim.fn.stdpath('state') .. '/shada/main.shada'

-- Disable editorconfig
vim.g.editorconfig = false

-- Set Python host prog if defined in environment
if os.getenv("NVIM_PYTHON3_HOST_PROG") then
  vim.g.python3_host_prog = os.getenv("NVIM_PYTHON3_HOST_PROG")
end

-- Enable diagnostics in insert mode
vim.diagnostic.config({
  update_in_insert = true,
})
EOL

# Create core/keymaps.lua
cat >"$NVIM_CONFIG_DIR/lua/core/keymaps.lua" <<'EOL'
-- Key mappings

-- Set leader key (also set in init.lua to ensure it's loaded early)
vim.g.mapleader = " "

-- File explorer
vim.keymap.set("n", "<leader>c", vim.cmd.Ex)

-- Moving lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in place
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Greatest remap ever: paste without losing current yank
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Clipboard integration
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Exit insert mode with Ctrl+c
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- TMUX sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Format buffer with LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Quickfix navigation
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Quick search and replace for word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Quick template for async function
vim.keymap.set("n", "<leader>ee", "oasync def func(): <Esc>")

-- Source current file
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
EOL

# Create core/lazy.lua
cat >"$NVIM_CONFIG_DIR/lua/core/lazy.lua" <<'EOL'
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ 
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath 
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    -- Import plugins configurations
    { import = "plugins" },
  },
  -- Configure lazy.nvim
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  -- Check for plugin updates
  checker = { enabled = true },
  -- Change install / update directory
  install = { colorscheme = { "gruvbox" } },
  ui = {
    border = "rounded",
  },
})
EOL

# Create core/autocmds.lua
cat >"$NVIM_CONFIG_DIR/lua/core/autocmds.lua" <<'EOL'
-- Autocommands

-- Create autocommand groups
local augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with just 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help",
    "man",
    "qf",
    "checkhealth",
    "lspinfo",
    "fugitive",
    "git",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Create directories when needed, when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
EOL

# Create plugins/colorscheme.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/colorscheme.lua" <<'EOL'
return {
  -- Gruvbox colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- Load before other plugins
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "",
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
  
  -- CyberDream colorscheme
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = true,
      })
      -- Uncomment to use cyberdream theme:
      -- vim.cmd("colorscheme cyberdream")
    end,
  },
  
  -- Transparent background
  {
    "xiyaowong/transparent.nvim",
    priority = 1000,
  },
}
EOL

# Create plugins/mason-workaround.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/mason-workaround.lua" <<'EOL'
-- Workaround for mason compatibility issues
-- See: https://github.com/LazyVim/LazyVim/issues/6039#issuecomment-2856227817
return {
  { "mason-org/mason.nvim", version = "^1.0.0" },
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
EOL

# Create plugins/lsp.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/lsp.lua" <<'EOL'
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
          -- "black", -- Python formatter
          "stylua", -- Lua formatter
          -- "prettierd", -- JavaScript/TypeScript/HTML/CSS/JSON formatter
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
EOL

# Create plugins/treesitter.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/treesitter.lua" <<'EOL'
return {
  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "java", "rust", "python", "javascript", "typescript", "c", "cpp" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },
  
  -- Treesitter playground for debugging
  {
    "nvim-treesitter/playground",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
EOL

# Create plugins/telescope.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/telescope.lua" <<'EOL'
return {
  -- Telescope for fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.7", -- Use latest stable version
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      
      -- Configure Telescope to match the old appearance
      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          -- Use a different layout strategy for better organization
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55, 
              results_width = 0.4,
              width = 0.87,
              height = 0.80,
              preview_cutoff = 120,
            },
          },
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "target/",
            "dist/",
            ".next/",
            "build/",
            "vendor/",
          },
          -- Custom keymaps as requested
          mappings = {
            i = {
              -- Use C-n and C-p for navigating through files
              ["<C-n>"] = "move_selection_next",
              ["<C-p>"] = "move_selection_previous",
              
              -- Use C-j and C-k for scrolling in the preview window
              ["<C-j>"] = "preview_scrolling_down",
              ["<C-k>"] = "preview_scrolling_up",
            },
            n = {
              -- Also apply in normal mode
              ["<C-n>"] = "move_selection_next",
              ["<C-p>"] = "move_selection_previous",
              ["<C-j>"] = "preview_scrolling_down",
              ["<C-k>"] = "preview_scrolling_up",
            },
          },
        },
        pickers = {
          -- Configure specific pickers with a standard layout (not dropdown)
          find_files = {
            -- Use normal layout with explicitly positioned preview
            hidden = true,
          },
          git_files = {
            -- Use normal layout with explicitly positioned preview
          },
          buffers = {
            -- Use normal layout with explicitly positioned preview
          },
        },
      })
      
      -- Set keymaps
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
      vim.keymap.set("n", "<C-p>", builtin.git_files, {})
      vim.keymap.set("n", "<leader>ps", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)
    end,
  },
}
EOL

# Create plugins/git.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/git.lua" <<'EOL'
return {
  -- Fugitive for Git integration
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    end,
  },
  
  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
          width = 180,
          height = 40,
        },
        on_open = function(term)
          -- Start in insert mode when lazygit opens
          vim.cmd("startinsert!")
          
          -- Create a buffer-local autocmd to stay in insert mode
          local bufnr = term.bufnr
          if bufnr then
            vim.api.nvim_create_autocmd("BufEnter", {
              buffer = bufnr,  -- Use buffer instead of pattern
              callback = function()
                vim.cmd("startinsert!")
              end,
              once = true,  -- Only trigger once per buffer enter
            })
          end
        end,
        on_exit = function(term)
          vim.api.nvim_buf_delete(term.bufnr, { force = true })
        end,
      })
      
      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end
      
      vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { noremap = true, silent = true })
    end,
  },
}
EOL

# Create plugins/harpoon.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/harpoon.lua" <<'EOL'
return {
  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      
      -- Setup harpoon
      harpoon:setup()
      
      -- Set keymaps
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      
      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-n>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-m>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
    end,
  },
}
EOL

# Create plugins/terminal.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/terminal.lua" <<'EOL'
return {
  -- ToggleTerm for integrated terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 14,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 10,
        start_in_insert = false,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = false,
        direction = "horizontal",
        close_on_exit = false,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
        },
      })
    end,
  },
}
EOL

# Create plugins/conform.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/conform.lua" <<'EOL'
return {
  -- Formatter configuration
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "black" },
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        svelte = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        bash = { "shfmt" },
        rust = { "rustfmt" },
      },
      -- Set up format-on-save
      format_on_save = function(bufnr)
        -- Don't autoformat these files
        local ignore_filetypes = { "sql", "java" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        -- Don't autoformat files in these directories
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    },
  },
}
EOL

# Create plugins/lint.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/lint.lua" <<'EOL'
return {
  -- Linter configuration
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Function to check if a specified executable exists in PATH
      local function executable_exists(exe)
        return vim.fn.executable(exe) == 1
      end

      -- Function to check if a file exists in the project or parent directories
      local function file_exists_in_project(filename)
        local current_dir = vim.fn.expand("%:p:h")
        local max_depth = 10 -- Limit search depth to avoid infinite loops
        local depth = 0

        while current_dir ~= "" and depth < max_depth do
          local filepath = current_dir .. "/" .. filename
          if vim.fn.filereadable(filepath) == 1 then
            return true
          end
          -- Go up one directory
          local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
          if parent_dir == current_dir then
            break -- Reached root directory
          end
          current_dir = parent_dir
          depth = depth + 1
        end
        return false
      end

      -- Configure linters per filetype with conditional checks
      lint.linters_by_ft = {
        python = executable_exists("ruff") and { "ruff" } or {},
        -- Only use eslint if it's available and if there's an ESLint config
        javascript = (executable_exists("eslint") and 
                    (file_exists_in_project(".eslintrc.js") or 
                     file_exists_in_project(".eslintrc.json") or 
                     file_exists_in_project(".eslintrc.yml") or 
                     file_exists_in_project(".eslintrc") or 
                     file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
        typescript = (executable_exists("eslint") and 
                    (file_exists_in_project(".eslintrc.js") or 
                     file_exists_in_project(".eslintrc.json") or 
                     file_exists_in_project(".eslintrc.yml") or 
                     file_exists_in_project(".eslintrc") or 
                     file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
        javascriptreact = (executable_exists("eslint") and 
                         (file_exists_in_project(".eslintrc.js") or 
                          file_exists_in_project(".eslintrc.json") or 
                          file_exists_in_project(".eslintrc.yml") or 
                          file_exists_in_project(".eslintrc") or 
                          file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
        typescriptreact = (executable_exists("eslint") and 
                         (file_exists_in_project(".eslintrc.js") or 
                          file_exists_in_project(".eslintrc.json") or 
                          file_exists_in_project(".eslintrc.yml") or 
                          file_exists_in_project(".eslintrc") or 
                          file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
        svelte = (executable_exists("eslint") and 
                (file_exists_in_project(".eslintrc.js") or 
                 file_exists_in_project(".eslintrc.json") or 
                 file_exists_in_project(".eslintrc.yml") or 
                 file_exists_in_project(".eslintrc") or 
                 file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
      }

      -- Set up a command to manually trigger linting
      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, {})

      -- Set up automatic linting with error handling
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only try to lint if there are linters defined for this filetype
          local ft = vim.bo.filetype
          if lint.linters_by_ft[ft] and #lint.linters_by_ft[ft] > 0 then
            -- Use pcall to catch any errors during linting
            local ok, err = pcall(lint.try_lint)
            if not ok then
              vim.notify("Linting error: " .. tostring(err), vim.log.levels.WARN)
            end
          end
        end,
      })
    end,
  },
}
EOL
cat >"$NVIM_CONFIG_DIR/lua/plugins/misc.lua" <<'EOL'
return {
  -- Undotree - visualize undo history
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },
  
  -- Neoscroll - smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      local neoscroll = require("neoscroll")
      require("neoscroll").setup({
        mappings = {
          '<C-u>', '<C-d>',
          'zz'
        },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing = 'quadratic',
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
        ignored_events = {},
      })
      
      local keymap = {
        ["<C-k>"] = function() neoscroll.ctrl_u({ duration = 200, easing = 'quadratic' }) end,
        ["<C-j>"] = function() neoscroll.ctrl_d({ duration = 200, easing = 'quadratic' }) end,
        ["<C-u>"] = function() neoscroll.scroll(-0.1, { move_cursor=true, duration = 100 }) end,
        ["<C-d>"] = function() neoscroll.scroll(0.1, { move_cursor=true, duration = 100 }) end,
        ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end,
      }
      
      local modes = { 'n', 'v', 'x' }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end
    end,
  },
}
EOL

# Create plugins/java.lua
cat >"$NVIM_CONFIG_DIR/lua/plugins/java.lua" <<'EOL'
return {
  -- Neotest for testing framework
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
      require("neotest").setup({
        adapters = {
          ["neotest-java"] = {
            -- Add any specific configuration here
          },
        },
      })
    end,
  },
  
  -- JDTLS for Java Development
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
}
EOL

# Create after/ftplugin/java.lua
mkdir -p "$NVIM_CONFIG_DIR/after/ftplugin"
cat >"$NVIM_CONFIG_DIR/after/ftplugin/java.lua" <<'EOL'
-- Custom configuration for Java files
local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify("JDTLS not found, skipping Java LSP setup", vim.log.levels.WARN)
  return
end

-- Find root directory (usually the git root)
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  root_dir = vim.fn.getcwd()
end

-- Get OS-specific path seperator
local path_sep = vim.loop.os_uname().sysname:match("Windows") and "\\" or "/"

-- Get OS name for proper config
local os_config = vim.loop.os_uname().sysname:match("Windows") and "win" or
                  vim.loop.os_uname().sysname:match("Linux") and "linux" or
                  vim.loop.os_uname().sysname:match("Darwin") and "mac" or "linux"

-- Setup Java environment
local home = os.getenv("HOME")
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local config_path = jdtls_path .. "/config_" .. os_config
local plugins_path = jdtls_path .. "/plugins"
local jar_path = vim.fn.glob(plugins_path .. "/org.eclipse.equinox.launcher_*.jar")

-- Project name for unique workspace 
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

-- JDTLS Configuration
local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", jar_path,
    "-configuration", config_path,
    "-data", workspace_dir
  },
  
  root_dir = root_dir,
  
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
        },
      },
      format = {
        enabled = true,
        settings = {
          url = home .. "/.config/nvim/language-servers/java-format.xml",
          profile = "GoogleStyle",
        }
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
    },
  },
  
  init_options = {
    bundles = {
      -- Java Debug extension
      vim.fn.glob(home .. "/.config/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1),
    },
  },
  
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  
  on_attach = function(client, bufnr)
    -- Regular LSP keybindings
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to Implementation" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = "Workspace Symbol" })
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { buffer = bufnr, desc = "Open Diagnostic" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous Diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, { buffer = bufnr, desc = "References" })
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
    vim.keymap.set("i", "<C-j>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
    
    -- JDTLS specific commands
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup.add_commands()
    
    -- Debugger keybindings
    vim.keymap.set("n", "<leader>jc", jdtls.compile, { buffer = bufnr, desc = "Compile Java" })
    vim.keymap.set("n", "<leader>jt", jdtls.test_class, { buffer = bufnr, desc = "Test Class" })
    vim.keymap.set("n", "<leader>jr", jdtls.test_nearest_method, { buffer = bufnr, desc = "Test Method" })
  end,
}

-- Start the JDTLS server
jdtls.start_or_attach(config)
EOL

# Create directory for language server configurations
mkdir -p "$NVIM_CONFIG_DIR/language-servers"

# Finish installation
echo -e "${GREEN}Successfully installed new Neovim configuration!${NC}"
echo -e "${YELLOW}Note:${NC} Your old configuration has been backed up to ${BACKUP_DIR}"
echo -e "${YELLOW}Note:${NC} For Java development, you may need to create the java-debug directory and build the extension."
echo -e ""
echo -e "${GREEN}Recommended next steps:${NC}"
echo -e "1. Start Neovim with 'nvim'"
echo -e "2. Run ':checkhealth' to verify the installation"
echo -e "3. For Java development setup: 
   mkdir -p ~/.config/nvim/java-debug
   cd ~/.config/nvim/java-debug
   git clone https://github.com/microsoft/java-debug.git .
   ./mvnw clean install"
echo -e ""
echo -e "Enjoy your new Neovim configuration!"
