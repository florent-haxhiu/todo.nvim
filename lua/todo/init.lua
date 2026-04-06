local M = {}

M.setup = function()
	-- nothing
end

local Todo = require("todo.todo")

M.add_todo = Todo.add_todo
M.view_todos = Todo.view_todos

return M
