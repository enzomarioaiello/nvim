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
