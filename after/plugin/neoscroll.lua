local neoscroll = require("neoscroll")
require('neoscroll').setup({
  mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
    '<C-u>', '<C-d>',
    'zz'
  },
  hide_cursor = true,          -- Hide cursor while scrolling
  stop_eof = true,             -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  easing = 'quadratic',           -- Default easing function
  pre_hook = nil,              -- Function to run before the scrolling animation starts
  post_hook = nil,             -- Function to run after the scrolling animation ends
  performance_mode = false,    -- Disable "Performance Mode" on all buffers.
  ignored_events = {           -- Events ignored while scrolling
  },
})
local keymap = {
  ["<C-k>"] = function() neoscroll.ctrl_u({ duration = 200, easing = 'quadratic' }) end;
  ["<C-j>"] = function() neoscroll.ctrl_d({ duration = 200, easing = 'quadratic' }) end;
  ["<C-u>"] = function() neoscroll.scroll(-0.1, { move_cursor=true; duration = 100 }) end;
  ["<C-d>"] = function() neoscroll.scroll(0.1, { move_cursor=true; duration = 100 }) end;
  ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end;
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(keymap) do
  vim.keymap.set(modes, key, func)
end
