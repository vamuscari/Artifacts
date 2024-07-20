return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      { "<leader>d", group = "[D]atabase" },
      { "<leader>f", group = "[F]ile" },
      { "<leader>g", group = "[G]it" },
      { "<leader>q", group = "[Q]uit/session" },
      { "<leader>r", group = "[R]un/debug" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>u", group = "[U]i" },
      { "<leader>w", group = "[W]indows" },
      { "<leader>x", group = "diagnostics/quickfix" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "d", group = "delete" },
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      -- NOTE: the code searches on string that have been converted to all lowercase. Do not try to match uppercase
      rules = {
        { pattern = "oil", icon = "󰙅", color = "green" },
        { pattern = "%[f%]ile", icon = "󰈔", color = "cyan" },
        { pattern = "%[g%]it", cat = "filetype", name = "git" },
        { pattern = "%[s%]earch", icon = " ", color = "green" },
        { pattern = "%[u%]i", icon = "󰙵 ", color = "cyan" },
        { pattern = "%[w%]indow", icon = " ", color = "blue" },
        -- { plugin = "fzf-lua", cat = "filetype", name = "fzf" },
        -- { plugin = "neo-tree.nvim", cat = "filetype", name = "neo-tree" },
        -- { plugin = "octo.nvim", cat = "filetype", name = "git" },
        -- { plugin = "yanky.nvim", icon = "󰅇", color = "yellow" },
        -- { plugin = "zen-mode.nvim", icon = "󱅻 ", color = "cyan" },
        -- { plugin = "telescope.nvim", pattern = "telescope", icon = "", color = "blue" },
        -- { plugin = "trouble.nvim", cat = "filetype", name = "trouble" },
        -- { plugin = "todo-comments.nvim", cat = "file", name = "TODO" },
        -- { plugin = "nvim-spectre", icon = "󰛔 ", color = "blue" },
        -- { plugin = "noice.nvim", pattern = "noice", icon = "󰈸", color = "orange" },
        -- { plugin = "persistence.nvim", icon = " ", color = "azure" },
        -- { plugin = "neotest", cat = "filetype", name = "neotest-summary" },
        -- { plugin = "lazy.nvim", cat = "filetype", name = "lazy" },
        -- { plugin = "CopilotChat.nvim", icon = " ", color = "orange" },
        -- { pattern = "%f[%a]git", cat = "filetype", name = "git" },
        -- { pattern = "terminal", icon = " ", color = "red" },
        -- { pattern = "find", icon = " ", color = "green" },
        -- { pattern = "search", icon = " ", color = "green" },
        -- { pattern = "test", cat = "filetype", name = "neotest-summary" },
        -- { pattern = "lazy", cat = "filetype", name = "lazy" },
        -- { pattern = "buffer", icon = "󰈔", color = "cyan" },
        -- { pattern = "file", icon = "󰈔", color = "cyan" },
        -- { pattern = "diagnostic", icon = "󱖫 ", color = "green" },
        -- { pattern = "format", icon = " ", color = "cyan" },
        -- { pattern = "debug", icon = "󰃤 ", color = "red" },
        -- { pattern = "code", icon = " ", color = "orange" },
        -- { pattern = "notif", icon = "󰵅 ", color = "blue" },
        -- { pattern = "toggle", icon = " ", color = "yellow" },
        -- { pattern = "session", icon = " ", color = "azure" },
        -- { pattern = "exit", icon = "󰈆 ", color = "red" },
        -- { pattern = "quit", icon = "󰈆 ", color = "red" },
        -- { pattern = "tab", icon = "󰓩 ", color = "purple" },
        -- { pattern = "ai", icon = " ", color = "green" },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show { global = false }
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
