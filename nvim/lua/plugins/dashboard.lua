return {
  {
    "vamuscari/dashboard-nvim",
    dir = "~/Repos/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup {
        config = {
          header = {
            type = "custom", --defualt, week, or custom
            text = Project_Name, --custom option
            font = "ANSI Regular", --custom font option
          },
        },
      }
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
}
