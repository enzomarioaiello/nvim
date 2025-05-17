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
