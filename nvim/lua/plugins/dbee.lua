return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  keys = {
    {
      "<leader>db",
      function()
        require("dbee").toggle()
      end,
      desc = "[D]b toggle",
    },
    {
      "<leader>de",
      function()
        ---@diagnostic disable-next-line: param-type-mismatch
        require("dbee").execute(vim.api.nvim_buf_get_lines(0, 0, -1, false))
      end,
      desc = "[D]b [E]xecute",
    },
  },
  config = function()
    require("dbee").setup()

    -- vim.keymap.set("n", "<leader>dd", function()
    --   require("dbee").open()
    --
    --   ---@diagnostic disable-next-line: param-type-mismatch
    --   local base = vim.fs.joinpath(vim.fn.stdpath "state", "dbee", "notes")
    --   local pattern = string.format("%s/.*", base)
    --   vim.filetype.add {
    --     extension = {
    --       sql = function(path, _)
    --         if path:match(pattern) then
    --           return "sql.dbee"
    --         end
    --
    --         return "sql"
    --       end,
    --     },
    --
    --     pattern = {
    --       [pattern] = "sql.dbee",
    --     },
    --   }
    -- end)
  end,
}
