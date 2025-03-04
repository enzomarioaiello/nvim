local tt = require("toggleterm")

tt.setup({
  size = 14,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 10,
  start_in_insert = false,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = false,
  direction = 'horizontal',
  close_on_exit = false,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    winblend = 0,
  },
})

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "curved",
    width = 180,
    height =  40,
  },
  on_exit = function (term)
    vim.api.nvim_buf_delete(term.bufnr, { force = true })
  end,
})

function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { noremap = true, silent = true }) 

return {}
