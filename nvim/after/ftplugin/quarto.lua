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

vim.keymap.set("n", "<localleader>mn", function()
  require("nabla").popup()
end, { desc = "[M]olten [N]abla", silent = true })
vim.keymap.set("n", "<localleader>ms", ":MoltenInit<CR>", { desc = "[M]olten [S]art", silent = true })
vim.keymap.set("n", "<localleader>mS", ":MoltenDeinit<CR>", { desc = "[M]olten [S]top", silent = true })
vim.keymap.set(
  "n",
  "<localleader>mel",
  ":MoltenEvaluateLine<CR>",
  { desc = "[M]olten [E]valuate [L]ine", silent = true }
)
vim.keymap.set(
  "n",
  "<localleader>mev",
  ":MoltenEvaluateVisual<CR>",
  { desc = "[M]olten [E]valuate [V]isual", silent = false }
)
vim.keymap.set(
  "n",
  "<localleader>meo",
  ":MoltenEvaluateOperator<CR>",
  { desc = "[M]olten [E]valuate [O]perator", silent = false }
)
vim.keymap.set(
  "n",
  "<localleader>mea",
  ":MoltenEvaluateArgument<CR>",
  { desc = "[M]olten [E]valuate [A]rgument", silent = false }
)

vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "[M]olten [D]elete", silent = false })
vim.keymap.set("n", "<localleader>mi", ":MoltenImagePopup<CR>", { desc = "[M]olten [I]mage Popup", silent = false })
vim.keymap.set("n", "<localleader>mw", ":MoltenSave<CR>", { desc = "[M]olten [W]rite", silent = false })
vim.keymap.set("n", "<localleader>ml", ":MoltenLoad<CR>", { desc = "[M]olten [L]oad", silent = false })
vim.keymap.set("n", "<localleader>mb", ":MoltenOpenInBrowser<CR>", { desc = "[M]olten to [B]rowser", silent = false })
vim.keymap.set("n", "<localleader>mos", ":MoltenShowOutput<CR>", { desc = "[M]olten [O]utput [S]how", silent = false })
vim.keymap.set("n", "<localleader>moh", ":MoltenHideOutput<CR>", { desc = "[M]olten [O]utput [H]ide", silent = false })
vim.keymap.set(
  "n",
  "<localleader>moe",
  ":MoltenEnterOutput<CR>",
  { desc = "[M]olten [O]utput [E]nter", silent = false }
)

vim.keymap.set("n", "]c", ":MoltenNext<CR>", { desc = "Molten Next", silent = false })
vim.keymap.set("n", "[c", ":MoltenPrev<CR>", { desc = "Molten Previous", silent = false })
vim.keymap.set("n", "mg", ":MoltenGoto<CR>", { desc = "Molten Goto", silent = false })
--vim.keymap.set("n", "<localleader>rm", ":MoltenInit<CR>", { desc = "[R]un [M]olten", silent = true })
