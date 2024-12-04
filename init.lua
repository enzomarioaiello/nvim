require("sasha")
require("sasha.remap")

-- :set nu (line numbers)
-- :set rnu (relative line numbers)


-- Default options for gruvbox colorshceme:
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
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
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})

require("cyberdream").setup({
    -- Enable transparent background
    transparent = true,
})


vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme cyberdream")
vim.g.python3_host_prog = os.getenv("NVIM_PYTHON3_HOST_PROG")

----------------------------------- DEPRECATED -----------------------------------
-- Function to update the Python interpreter
--function UpdatePythonInterpreter()
--    -- Get the VIRTUAL_ENV environment variable
--    local venv_path = os.getenv("NVIM_PYTHON3_HOST_PROG")
--    -- If VIRTUAL_ENV is set, update the python3_host_prog
--    if venv_path ~= nil and venv_path ~= "" then
--        vim.g.python3_host_prog = venv_path
--        -- Print a message to confirm the interpreter has been updated
--        print("Python interpreter updated successfully")
--    else
--        print("VIRTUAL_ENV is not set")
--    end
--end
--
---- Create a custom command to source the virtual environment and update the Python interpreter
--vim.api.nvim_create_user_command(
--    'UpdatePythonInterpreter',
--    function()
--        UpdatePythonInterpreter()
--    end,
--    {}
--)
