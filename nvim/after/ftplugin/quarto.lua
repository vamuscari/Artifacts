-- NOTE: This is centered around the Molten.Nvim plugin

-- Keybindings
local runner = require "quarto.runner"
vim.keymap.set("n", "<localleader>rm", ":MoltenInit<CR>", { desc = "[R]un [M]olten", silent = true })
vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "[R]un [C]ell", silent = true })
vim.keymap.set("n", "<localleader>rC", runner.run_above, { desc = "[R]un [C]ell and above", silent = true })
vim.keymap.set("n", "<localleader>ra", runner.run_all, { desc = "[R]un [A]ll cells", silent = true })
vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "[R]un [L]ine", silent = true })
vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "[R]un visual range", silent = true })
vim.keymap.set("n", "<localleader>rA", function()
  runner.run_all(true)
end, { desc = "run all cells of all languages", silent = true })

vim.keymap.set("n", "<localleader>m", function()
  require("nabla").popup()
end, { desc = "[M]ath", silent = true })
