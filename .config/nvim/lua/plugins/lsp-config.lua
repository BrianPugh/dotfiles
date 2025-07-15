return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp" },  -- notably: remove .proto
      },
    },
    diagnostics = {
      virtual_text = false, -- Disable virtual text (code issues)
    },
    capabilities = {
      signatureHelp = false, -- Disable signature help
    },
  },
}
