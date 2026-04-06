local M = {}

local data_path
local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
if vim.v.shell_error == 0 then
	data_path = root
else
	data_path = vim.fn.getcwd()
end

---@param todo Todo
local function write_to_file(todo)
	---@type table<Todo>
	local lines

	local path = data_path .. "/todos.json"
	if vim.fn.filereadable(path) == 1 then
		lines = vim.fn.json_decode(vim.fn.readfile(path))
	else
		lines = {}
	end
	table.insert(lines, todo)
	vim.fn.writefile({ vim.fn.json_encode(lines) }, path)
end

---@class Todo
---@field id integer
---@field title string
---@field done boolean
---@field tags table
local Todo = {}
Todo.__index = Todo

function Todo.new(opts)
	return setmetatable({
		id = opts.id,
		title = opts.title,
		done = opts.done or false,
		tags = opts.tags or {},
	}, Todo)
end

function Todo:complete()
	self.done = true
end

function Todo:__tostring()
	return string.format("[%s] %s", self.done and "x" or " ", self.title)
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

---@param lines table<string>
local function open_win(lines)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_open_win(buf, true,
		{ relative = "win", row = 25, col = 25, width = 30, height = 30, title = "Todo", border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" } })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	return buf
end

local function add_todo(opts)
	---@type Todo
	local todo = Todo.new(opts)
	write_to_file(todo)
end

local function view_todos()
	---@type table<[Todo]>
	local lines = vim.fn.json_decode(vim.fn.readfile(data_path .. "/todos.json"))

	local show_lines_on_win = get_lines_in_table(lines)

	open_win(show_lines_on_win)
	return show_lines_on_win
end

M.add_todo = add_todo
M.view_todos = view_todos
M.complete_todo = complete_todo

return M
