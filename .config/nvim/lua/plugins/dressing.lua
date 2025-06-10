return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      -- Position the input box near the cursor
      override = function(conf)
        conf.col = -1 -- Align with cursor
        conf.row = 0 -- Show above the cursor
        conf.border = "rounded"
        return conf
      end,
      -- Additional settings for the input window
      win_options = {
        winblend = 0, -- No transparency
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    },
  },
}
