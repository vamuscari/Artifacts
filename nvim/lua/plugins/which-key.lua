return {
  "folke/which-key.nvim",
  -- event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n", "v" },
      ["d"] = { name = "+delete" },
      ["g"] = { name = "+goto" },
      ["gs"] = { name = "+surround" },
      ["z"] = { name = "+fold" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<leader>d"] = { name = "+[D]atabase" },
      ["<leader>c"] = { name = "+[C]ode" },
      ["<leader>f"] = { name = "+[f]ile/find" },
      ["<leader>g"] = { name = "+[G]it" },
      ["<leader>q"] = { name = "+[Q]uit/session" },
      ["<leader>r"] = { name = "+[R]un/debug" },
      ["<leader>s"] = { name = "+[S]earch" },
      ["<leader>u"] = { name = "+[U]i" },
      ["<leader>w"] = { name = "+[W]indows" },
      ["<leader>x"] = { name = "+diagnostics/quickfix" },
    },
  },
  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
