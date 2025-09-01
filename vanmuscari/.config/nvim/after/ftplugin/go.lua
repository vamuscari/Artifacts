vim.opt_local.expandtab = false

vim.keymap.set("n", "<leader>rd", function()
  require("dap-go").debug_test()
end, { buffer = 0 })

vim.opt_local.commentstring = "// %s"
