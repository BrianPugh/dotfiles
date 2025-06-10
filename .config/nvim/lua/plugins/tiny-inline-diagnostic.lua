return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000,
  opts = {
    preset = "ghost",
    virt_texts = {
      priority = 999999999,
    },
    transparent_bg = false,
  },
}
