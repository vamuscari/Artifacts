return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  brach = "main",
  lazy = false,
  config = function()
    local configs = require "nvim-treesitter.configs"

    ---@diagnostic disable-next-line: missing-fields
    configs.setup {
      highlight = { enable = true },
      --indent = { enable = true },
      ensure_installed = {
        -- General Languages
        "c",
        "zig",
        "perl",

        -- Mobile
        "dart",

        -- Web
        "html",
        "css",
        "scss",
        "javascript",
        "jsdoc",
        "jsonc",
        "markdown",
        "markdown_inline",
        "tsx",
        "typescript",
        "terraform",
        "angular",

        -- Data Science
        "python",
        "julia",
        "r",

        -- DB / Data
        "json",
        "sql",
        "query",
        "xml",
        "yaml",
        "toml",

        -- System
        "regex",
        "diff",
        "bash",
        "lua",
        "luadoc",
        "luap",
        "vim",
        "vimdoc",
        "ssh_config",
        "tmux",
      },
      -- List of parsers to ignore installing (or "all")
      ignore_install = {
        "csv", -- Conflics with rainbow csv. Also, its highlighting is terrible
        "tsv",
      },
      sync_install = false,
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
      auto_install = true,
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    }
  end,
}
