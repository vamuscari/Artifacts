return {
  { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dev = false,
    opts = {
      lspFeatures = {
        languages = { "r", "python", "julia", "bash", "lua", "html", "dot", "javascript", "typescript", "ojs" },
      },
      codeRunner = {
        enabled = true,
        default_method = "slime",
      },
      keymap = {
        hover = "K",
        definition = "gd",
        -- rename = "<leader>rn",
        references = "gr",
        format = "<leader>gf",
      },
    },
    dependencies = {
      -- for language features in code cells
      -- configured in lua/plugins/lsp.lua and
      -- added as a nvim-cmp source in lua/plugins/completion.lua
      "jmbuhr/otter.nvim",
    },
  },

  { -- directly open ipynb files as quarto docuements
    -- and convert back behind the scenes
    -- needs:
    -- pip install jupytext
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto", -- you can set whatever filetype you want here
        },
        r = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto", -- you can set whatever filetype you want here
        },
      },
    },
  },

  { -- paste an image from the clipboard or drag-and-drop
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    ft = { "markdown", "quarto", "latex" },
    opts = {
      default = {
        dir_path = "img",
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
        quarto = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("img-clip").setup(opts)
      vim.keymap.set("n", "<leader>pi", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
    end,
  },

  { -- preview equations
    "jbyuki/nabla.nvim",
    lazy = true,
    ft = { "ipynb", "quarto", "qmd" },
    keys = {
      { "<leader>nm", ':lua require"nabla".toggle_virt()<cr>', desc = "[N]vim toggle [m]ath equations" },
    },
  },
  {
    "benlubas/molten-nvim",
    -- {
    --   -- see the image.nvim readme for more information about configuring this plugin
    --   "3rd/image.nvim",
    --   opts = {
    --     backend = "kitty", -- whatever backend you would like to use
    --     max_width = 100,
    --     max_height = 12,
    --     max_height_window_percentage = math.huge,
    --     max_width_window_percentage = math.huge,
    --     window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
    --     window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    --   },
    -- },
    lazy = true,
    -- enabled = false,
    ft = { "ipynb", "quarto", "qmd" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_wrap_output = true
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_auto_open_output = false
    end,
  },
}
