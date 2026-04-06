local M = {}

---@class Todo
---@field title string
---@field done boolean
---@field tags table

local data_path
local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
if vim.v.shell_error == 0 then
	data_path = root
else
	data_path = vim.fn.getcwd()
end

local path = data_path .. "/todos.json"

local function init_file()
	if vim.fn.filereadable(path) == 1 then return end
	vim.fn.writefile({ vim.fn.json_encode({}) }, path)
end

init_file()

---@param todo Todo
local function write_to_file(todo)
	---@type table<Todo>
	local lines = vim.fn.json_decode(vim.fn.readfile(path))
	table.insert(lines, todo)
	vim.fn.writefile({ vim.fn.json_encode(lines) }, path)
end

---@return table<string>
local function get_lines_in_table(lines)
	---@type table<string>
	local show_lines_on_win = {}

	for _, line in pairs(lines) do
		table.insert(show_lines_on_win, string.format("[%s] %s", line.done and "x" or " ", line.title))
	end
	return show_lines_on_win
end

---@param title string
local function add_todo(title)
	write_to_file({ title = title, done = false, tags = {} })
end

local function read_todos()
	---@type table<[Todo]>
	return vim.fn.json_decode(vim.fn.readfile(path))
end

local function complete_todo(row)
	local lines = read_todos()
	lines[row].done = true
	vim.fn.writefile({ vim.fn.json_encode(lines) }, path)
end

local function remove_todo(row)
	local lines = read_todos()
	table.remove(lines, row)
	vim.fn.writefile({ vim.fn.json_encode(lines) }, path)
end

local function open_win()
	local buf = vim.api.nvim_create_buf(false, true)
	--- Make sure that neovim doesn't save the file
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

	--- Get a sensible width and height
	local width = math.floor(vim.o.columns * 0.4)
	local height = math.floor(vim.o.lines * 0.4)
	local win_row = (vim.o.lines - height) / 2
	local win_col = (vim.o.columns - width) / 2

	--- Open the window with the settings for the floating window
	vim.api.nvim_open_win(buf, true,
		{ relative = "editor", row = win_row, col = win_col, height = height, width = width, title = "Todo", border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" } })
	--- Set the lines in the window
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, get_lines_in_table(read_todos()))

	vim.keymap.set("n", "<CR>", function()
		local row = vim.api.nvim_win_get_cursor(0)
		complete_todo(row[1])
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, get_lines_in_table(read_todos()))
	end, { buffer = buf })

	vim.keymap.set("n", "a", function()
		local title = vim.fn.input("Todo: ")
		if title ~= "" then
			add_todo(title)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, get_lines_in_table(read_todos()))
		end
	end, { buffer = buf })

	vim.keymap.set("n", "d", function()
		local row = vim.api.nvim_win_get_cursor(0)
		remove_todo(row[1])
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, get_lines_in_table(read_todos()))
	end, { buffer = buf, nowait = true })

	return buf
end

M.todo = open_win

return M
