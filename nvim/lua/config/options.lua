local opt = vim.opt

opt.inccommand = "split"

opt.smartcase = true
opt.ignorecase = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
vim.bo.softtabstop = 2

opt.termguicolors = true
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = "yes"
opt.shada = { "'10", "<0", "s10", "h" }

opt.clipboard = "unnamedplus"
