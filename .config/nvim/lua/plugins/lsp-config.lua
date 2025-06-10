return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      virtual_text = false, -- Disable virtual text (code issues)
    },
    capabilities = {
      signatureHelp = false, -- Disable signature help
    },
  },
}
