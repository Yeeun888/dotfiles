-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Custom command to yank entire buffer to clipboard
vim.api.nvim_create_user_command("YankAll", function()
	-- Save current cursor position
	local save_pos = vim.fn.getpos(".")
	-- Yank entire buffer to clipboard register
	vim.cmd('normal! gg"+yG')
	-- Restore cursor position
	vim.fn.setpos(".", save_pos)
	-- Use echo instead of print to avoid "Press ENTER" prompt
	vim.cmd('echo "Yanked entire buffer to clipboard"')
end, { desc = "Yank entire buffer to clipboard" })

-- Custom command to yank range to a new scratch buffer
vim.api.nvim_create_user_command("YankBuffer", function(opts)
	local start_line = opts.line1
	local end_line = opts.line2

	-- Get the lines from the range
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	-- Create a new scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- Open the buffer in a new split
	vim.cmd("split")
	vim.api.nvim_win_set_buf(0, buf)

	-- Set buffer options
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
end, { range = true, desc = "Yank range to new scratch buffer" })
