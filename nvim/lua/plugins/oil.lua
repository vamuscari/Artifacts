return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup {
      columns = { "icon" },
      default_file_explorer = true,

      keymaps = {
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
    }

    -- Open parent directory in current window
    -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil (Explorer)" })

    -- Open parent directory in floating window
    vim.keymap.set("n", "<leader>fo", require("oil").toggle_float, { desc = "[F]ile [O]il Explorer" })
  end,
}
