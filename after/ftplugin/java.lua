-- Custom configuration for Java files
local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify("JDTLS not found, skipping Java LSP setup", vim.log.levels.WARN)
  return
end

-- Find root directory (usually the git root)
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  root_dir = vim.fn.getcwd()
end

-- Get OS-specific path seperator
local path_sep = vim.loop.os_uname().sysname:match("Windows") and "\\" or "/"

-- Get OS name for proper config
local os_config = vim.loop.os_uname().sysname:match("Windows") and "win" or
                  vim.loop.os_uname().sysname:match("Linux") and "linux" or
                  vim.loop.os_uname().sysname:match("Darwin") and "mac" or "linux"

-- Setup Java environment
local home = os.getenv("HOME")
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local config_path = jdtls_path .. "/config_" .. os_config
local plugins_path = jdtls_path .. "/plugins"
local jar_path = vim.fn.glob(plugins_path .. "/org.eclipse.equinox.launcher_*.jar")

-- Project name for unique workspace 
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

-- JDTLS Configuration
local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", jar_path,
    "-configuration", config_path,
    "-data", workspace_dir
  },
  
  root_dir = root_dir,
  
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.mockito.Mockito.*",
          "org.mockito.ArgumentMatchers.*",
        },
      },
      format = {
        enabled = true,
        settings = {
          url = home .. "/.config/nvim/language-servers/java-format.xml",
          profile = "GoogleStyle",
        }
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
    },
  },
  
  init_options = {
    bundles = {
      -- Java Debug extension
      vim.fn.glob(home .. "/.config/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1),
    },
  },
  
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  
  on_attach = function(client, bufnr)
    -- Regular LSP keybindings
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to Implementation" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = "Workspace Symbol" })
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { buffer = bufnr, desc = "Open Diagnostic" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous Diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, { buffer = bufnr, desc = "References" })
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
    vim.keymap.set("i", "<C-j>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
    
    -- JDTLS specific commands
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup.add_commands()
    
    -- Debugger keybindings
    vim.keymap.set("n", "<leader>jc", jdtls.compile, { buffer = bufnr, desc = "Compile Java" })
    vim.keymap.set("n", "<leader>jt", jdtls.test_class, { buffer = bufnr, desc = "Test Class" })
    vim.keymap.set("n", "<leader>jr", jdtls.test_nearest_method, { buffer = bufnr, desc = "Test Method" })
  end,
}

-- Start the JDTLS server
jdtls.start_or_attach(config)
