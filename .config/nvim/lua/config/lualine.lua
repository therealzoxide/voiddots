-- Edit of: Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

local colors = {
	black = "#000000",
	red = "#FF0000",
	green = "#00FF00",
	yellow = "#FFFF00",
	blue = "#5C5CFF",
	magenta = "#FF00FF",
	cyan = "#00FFFF",
	white = "#FFFFFF",
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
	end,
		hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand('%:p:h')
		local gitdir = vim.fn.finddir('.git', filepath .. ';')
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local config = {
	options = {
		component_separators = '',
		section_separators = '',
		theme = {
			normal = { c = { fg = colors.white, bg = colors.black } },
			inactive = { c = { fg = colors.white, bg = colors.black } },
		},
	},
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left {
	function()
		return ' '
	end,
	color = { fg = colors.cyan },
	padding = { left = 0, right = 1 },
}

ins_left {
	function()
		local mode = vim.fn.mode()
		local mode_name = {
			n = 'NORMAL',
			i = 'INSERT',
			v = 'VISUAL',
			[''] = 'VISUAL BLOCK',
			V = 'VISUAL LINE',
			c = 'COMMAND',
			R = 'REPLACE',
			s = 'SELECT',
			S = 'SELECT LINE',
			[''] = 'SELECT BLOCK',
		}
		return mode_name[mode] or mode:upper()
		end,
	color = { fg = colors.cyan},
	padding = { right = 1 },
}

ins_left {
	'filesize',
	cond = conditions.buffer_not_empty,
}

ins_left {
	'filename',
	cond = conditions.buffer_not_empty,
	color = { fg = colors.cyan, gui = 'bold' },
}

ins_left { 'location' }

ins_left { 'progress', color = { fg = colors.cyan, gui = 'bold' } }

ins_left {
	'diagnostics',
	sources = { 'nvim_diagnostic' },
	symbols = { error = ' ', warn = ' ', info = ' ' },
	diagnostics_color = {
		error = { fg = colors.red },
		warn = { fg = colors.yellow },
		info = { fg = colors.cyan },
	},
}

ins_right {
	'o:encoding',
	fmt = string.upper,
	cond = conditions.hide_in_width,
	color = { fg = colors.cyan, gui = 'bold' },
}

ins_right {
	'fileformat',
	fmt = string.upper,
	icons_enabled = false,
	color = { fg = colors.cyan, gui = 'bold' },
}

ins_right {
	'branch',
	icon = '',
	color = { fg = colors.cyan, gui = 'bold' },
}

ins_right {
	'diff',
	symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.magenta },
		removed = { fg = colors.cyan },
	},
	cond = conditions.hide_in_width,
}

ins_right {
	function()
		return ''
	end,
	color = { fg = colors.cyan },
	padding = { left = 1 },
}

lualine.setup(config)
