require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local unmap = vim.keymap.del

-- 删除默认配置的代码树打开影射
unmap("n", "<leader>e")
unmap("n", "<leader>x")
unmap("n", "<leader>b")


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- 使 ; 同步为 :
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- lsp 重命名
map("n", "grn", vim.lsp.buf.rename)
map("n", "gra", vim.lsp.buf.code_action)
map("n", "grr", vim.lsp.buf.references)
map("i", "<C-s>", vim.lsp.buf.signature_help)

map("n", "L", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "H", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

-- buffer 管理
map("n", "<leader>bx", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "buffer new" })

