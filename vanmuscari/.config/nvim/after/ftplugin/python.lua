-- Show line after desired maximum text width

-- Keybindings
vim.keymap.set("n", "<localleader>rc", function()
  require("dap-python").test_class()
end, { buffer = 0, desc = "[R]un [C]lass" })
vim.keymap.set("n", "<localleader>rd", function()
  require("dap-python").test_method()
end, { buffer = 0, desc = "[R]un [F]unction" })

-- Indentation
vim.g.pyindent_open_paren = "shiftwidth()"
vim.g.pyindent_continue = "shiftwidth()"

-- nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
-- nnoremap <silent> <leader>df :lua require('dap-python').test_class()<CR>
-- vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>

-- vim.opt_local.commentstring = "# %s"
