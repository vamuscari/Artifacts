-- bootstrap lazy.nvim, LazyVim and your plugins
--[[
-- Setup initial configuration,
-- 
-- Primarily just download and execute lazy.nvim
--]]

vim.uv = vim.uv or vim.loop

vim.g.mapleader = " "
vim.g.maplocalleader = " "

Project_Dir = os.getenv "TSX_PROJECT_DIR"
Project_Name = os.getenv "TSX_PROJECT_NAME"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

-- Add lazy to the `runtimepath`, this allows us to `require` it.
vim.opt.rtp:prepend(lazypath)

-- Default vim configurations
require "config.options"

-- Default vim keymaps
require "config.keymaps"

-- File types for Angular
require "config.angular"

-- Set up lazy, and load my `lua/custom/plugins/` folder
require("lazy").setup {
  spec = {
    -- import plugins
    { import = "plugins" },
  },
  checker = { enabled = false }, -- automatically check for plugin updates
  change_detection = {
    notify = false,
  },
  -- install = { colorscheme = { "tokyonight" } },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
