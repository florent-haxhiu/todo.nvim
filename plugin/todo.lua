--- Test todo
vim.api.nvim_create_user_command("Todo", function()
	require("todo").view_todos()
end, {})

--- Add todo
vim.api.nvim_create_user_command("TodoAdd", function(cmd_opts)
	require("todo").add_todo({ title = cmd_opts.args })
end, { nargs = "+" })

vim.api.nvim_create_user_command("TodoView", function()
	require("todo").view_todos()
end, {})

vim.api.nvim_create_user_command("TodoComplete", function(cmd_opts)
	require("todo").complete_todo({ title = cmd_opts.args })
end, {})
