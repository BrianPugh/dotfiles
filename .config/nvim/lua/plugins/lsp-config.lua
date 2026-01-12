return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        capabilities = {
          signatureHelp = false, -- Disable signature help
        },
      },
      clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp" },  -- notably: remove .proto
      },
    },
    diagnostics = {
      virtual_text = false, -- Disable virtual text (code issues)
    },
  },
}
