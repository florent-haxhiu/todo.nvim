local M = {}

M.setup = function()
	-- nothing
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
end

local function view_todos(opts)
	---@type Todo
end

M.add_todo = add_todo

return M
