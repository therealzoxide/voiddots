vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/rcarriga/nvim-notify",
	"https://github.com/startup-nvim/startup.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope-file-browser.nvim",
	"https://github.com/bjarneo/pixel.nvim",
})

vim.cmd.colorscheme("pixel")
require("config.lualine")
require("startup").setup({theme = "miyabi", disable_statusline = true,})


vim.o.number = true
vim.o.list = true
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.tabstop=2
vim.o.shiftwidth=2
