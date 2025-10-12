-- Swift-specific configuration
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.textwidth = 100

-- Swift-specific keymaps
local map = vim.keymap.set
local opts = { buffer = true, silent = true }

-- Build, test, and run shortcuts - using the established [R]un/debug namespace
map("n", "<leader>rB", ":!swift build<CR>", vim.tbl_extend("force", opts, { desc = "[R]un Swift [B]uild" }))
map("n", "<leader>rt", ":!swift test<CR>", vim.tbl_extend("force", opts, { desc = "[R]un Swift [T]est" }))
map("n", "<leader>rr", ":!swift run<CR>", vim.tbl_extend("force", opts, { desc = "[R]un Swift [R]un" }))

-- Package Manager shortcuts
map("n", "<leader>rpi", ":!swift package init<CR>", vim.tbl_extend("force", opts, { desc = "[R]un [P]ackage [I]nit" }))
map("n", "<leader>rpu", ":!swift package update<CR>", vim.tbl_extend("force", opts, { desc = "[R]un [P]ackage [U]pdate" }))

-- Additional Swift development shortcuts
map("n", "<leader>rw", ":!swift build --watch<CR>", vim.tbl_extend("force", opts, { desc = "[R]un Swift [W]atch build" }))
map("n", "<leader>rR", ":!swift build --configuration release<CR>", vim.tbl_extend("force", opts, { desc = "[R]un Swift [R]elease build" }))
map("n", "<leader>rpr", ":!swift package resolve<CR>", vim.tbl_extend("force", opts, { desc = "[R]un [P]ackage [R]esolve" }))
map("n", "<leader>rpc", ":!swift package clean<CR>", vim.tbl_extend("force", opts, { desc = "[R]un [P]ackage [C]lean" }))