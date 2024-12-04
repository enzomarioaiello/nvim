require('lsp-zero')
require('lspconfig').intelephense.setup({})

local lsp_zero = require('lsp-zero')

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
---@diagnostic disable-next-line: unused-local
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({select = true}),
	['<C-Space>'] = cmp.mapping.complete(),
})

lsp_zero.set_preferences({
	sign_icons = { }
})

---@diagnostic disable-next-line: unused-local
lsp_zero.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr}

	lsp_zero.default_keymaps(opts)
	-- use :help lsp-zero-keybindings to check command descriptions
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.openfloat() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vgu", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-j>", function() vim.lsp.buf.signature_help() end, opts)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'rust_analyzer', 'eslint', 'lua_ls'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})
