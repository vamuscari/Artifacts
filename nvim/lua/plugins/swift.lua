return {
  -- Enhanced Swift support
  {
    "keith/swift.vim",
    ft = "swift",
    config = function()
      -- Additional Swift syntax support
      vim.g.swift_no_conceal = 1 -- Disable concealing for better readability
    end,
  },

  -- iOS/macOS development with Xcode
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-tree.lua", -- optional, for project manager integration
    },
    config = function()
      require("xcodebuild").setup({
        -- Automatically show build logs
        show_build_progress_bar = true,
        -- Show notifications for build status
        restore_on_start = true,
        -- Auto-save files before building
        auto_save = true,
        -- Logs and reports
        logs = {
          auto_open_on_success_tests = false,
          auto_open_on_failed_tests = true,
          auto_open_on_success_build = false,
          auto_open_on_failed_build = true,
          auto_close_on_app_launch = false,
        },
      })

      -- Key mappings for xcodebuild
      local opts = { silent = true }
      vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", vim.tbl_extend("force", opts, { desc = "[X]code [B]uild" }))
      vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", vim.tbl_extend("force", opts, { desc = "[X]code Build & [R]un" }))
      vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", vim.tbl_extend("force", opts, { desc = "[X]code [T]est" }))
      vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", vim.tbl_extend("force", opts, { desc = "[X]code [T]est Class" }))
      vim.keymap.set("n", "<leader>x.", "<cmd>XcodebuildTestSelected<cr>", vim.tbl_extend("force", opts, { desc = "[X]code Test Selected" }))
      vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", vim.tbl_extend("force", opts, { desc = "[X]code Toggle [C]ode Coverage" }))
      vim.keymap.set("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", vim.tbl_extend("force", opts, { desc = "[X]code Show [C]overage Report" }))
      vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", vim.tbl_extend("force", opts, { desc = "[X]code Toggle [L]ogs" }))
      vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildSelectScheme<cr>", vim.tbl_extend("force", opts, { desc = "[X]code Select [S]cheme" }))
      vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", vim.tbl_extend("force", opts, { desc = "[X]code Select [D]evice" }))
      vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildPicker<cr>", vim.tbl_extend("force", opts, { desc = "[X]code [P]icker" }))
      vim.keymap.set("n", "<leader>xq", "<cmd>Telescope quickfix<cr>", vim.tbl_extend("force", opts, { desc = "[X]code [Q]uickfix" }))
      vim.keymap.set("n", "<leader>xx", "<cmd>XcodebuildQuickfixLine<cr>", vim.tbl_extend("force", opts, { desc = "[X]code Quickfi[x] Line" }))
      vim.keymap.set("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", vim.tbl_extend("force", opts, { desc = "[X]code Code [A]ctions" }))
    end,
  },

  -- Manual LSP configuration for sourcekit-lsp
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure sourcekit-lsp is configured if available
      if vim.fn.executable("sourcekit-lsp") == 1 then
        local lspconfig = require("lspconfig")

        -- Get capabilities from cmp_nvim_lsp
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        -- Manually enable file watching capabilities as required by sourcekit-lsp
        capabilities.workspace = capabilities.workspace or {}
        capabilities.workspace.didChangeWatchedFiles = {
          dynamicRegistration = true,
        }

        -- Configure sourcekit-lsp manually since Mason doesn't support it
        lspconfig.sourcekit.setup({
          cmd = { "sourcekit-lsp" },
          filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
          capabilities = capabilities,
          root_dir = function(filename)
            -- Look for Package.swift, Xcode project, or git repo
            return lspconfig.util.root_pattern("Package.swift", "*.xcodeproj", "*.xcworkspace")(filename)
              or lspconfig.util.find_git_ancestor(filename)
              or lspconfig.util.path.dirname(filename)
          end,
          settings = {},
        })
      end
    end,
  },
}