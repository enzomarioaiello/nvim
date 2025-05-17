return {
  -- Linter configuration
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Function to check if a specified executable exists in PATH
      local function executable_exists(exe)
        return vim.fn.executable(exe) == 1
      end

      -- Function to check if a file exists in the project or parent directories
      local function file_exists_in_project(filename)
        local current_dir = vim.fn.expand("%:p:h")
        local max_depth = 10 -- Limit search depth to avoid infinite loops
        local depth = 0

        while current_dir ~= "" and depth < max_depth do
          local filepath = current_dir .. "/" .. filename
          if vim.fn.filereadable(filepath) == 1 then
            return true
          end
          -- Go up one directory
          local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
          if parent_dir == current_dir then
            break -- Reached root directory
          end
          current_dir = parent_dir
          depth = depth + 1
        end
        return false
      end

      -- Configure linters per filetype with conditional checks
      lint.linters_by_ft = {
        python = executable_exists("ruff") and { "ruff" } or {},
        -- Only use eslint if it's available and if there's an ESLint config
        javascript = (executable_exists("eslint") and 
                    (file_exists_in_project(".eslintrc.js") or 
                     file_exists_in_project(".eslintrc.json") or 
                     file_exists_in_project(".eslintrc.yml") or 
                     file_exists_in_project(".eslintrc") or 
                     file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
        typescript = (executable_exists("eslint") and 
                    (file_exists_in_project(".eslintrc.js") or 
                     file_exists_in_project(".eslintrc.json") or 
                     file_exists_in_project(".eslintrc.yml") or 
                     file_exists_in_project(".eslintrc") or 
                     file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
        javascriptreact = (executable_exists("eslint") and 
                         (file_exists_in_project(".eslintrc.js") or 
                          file_exists_in_project(".eslintrc.json") or 
                          file_exists_in_project(".eslintrc.yml") or 
                          file_exists_in_project(".eslintrc") or 
                          file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
        typescriptreact = (executable_exists("eslint") and 
                         (file_exists_in_project(".eslintrc.js") or 
                          file_exists_in_project(".eslintrc.json") or 
                          file_exists_in_project(".eslintrc.yml") or 
                          file_exists_in_project(".eslintrc") or 
                          file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
        svelte = (executable_exists("eslint") and 
                (file_exists_in_project(".eslintrc.js") or 
                 file_exists_in_project(".eslintrc.json") or 
                 file_exists_in_project(".eslintrc.yml") or 
                 file_exists_in_project(".eslintrc") or 
                 file_exists_in_project(".eslintrc.yaml"))) and { "eslint" } or {},
      }

      -- Set up a command to manually trigger linting
      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, {})

      -- Set up automatic linting with error handling
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only try to lint if there are linters defined for this filetype
          local ft = vim.bo.filetype
          if lint.linters_by_ft[ft] and #lint.linters_by_ft[ft] > 0 then
            -- Use pcall to catch any errors during linting
            local ok, err = pcall(lint.try_lint)
            if not ok then
              vim.notify("Linting error: " .. tostring(err), vim.log.levels.WARN)
            end
          end
        end,
      })
    end,
  },
}
