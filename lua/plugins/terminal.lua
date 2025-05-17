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
