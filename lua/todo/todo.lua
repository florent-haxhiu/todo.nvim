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
	vim.fn.writefile({vim.fn.json_encode(lines)}, path)
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

local function add_todo(opts)
	---@type Todo
	local todo = Todo.new(opts)
	print(tostring(todo))
	write_to_file(todo)
end

local function view_todos(opts)
	---@type table<[Todo]> 
	local lines = vim.fn.json_decode(vim.fn.readfile(data_path .. "/todos.json"))
	for i, line in pairs(lines) do
		print(string.format("[%s] %s", line.done and "x" or " ", line.title))
	end
end

local function complete_todo(opts)

end

M.add_todo = add_todo
M.view_todos = view_todos
M.complete_todo = complete_todo

return M
