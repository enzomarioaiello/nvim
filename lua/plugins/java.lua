return {
  -- Neotest for testing framework
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcasia/neotest-java",
    },
    ft = { "java" },
    config = function()
      require("neotest").setup({
        adapters = {
          ["neotest-java"] = {
            -- Add any specific configuration here
          },
        },
      })
    end,
  },
  
  -- JDTLS for Java Development
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
}
