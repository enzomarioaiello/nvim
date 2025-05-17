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
