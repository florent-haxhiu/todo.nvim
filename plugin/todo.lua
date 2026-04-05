--- Test todo 
vim.api.nvim_create_user_command("TodoStart", function()
	require("todo").print_hello_world()
end, {})

--- Add todo
vim.api.nvim_create_user_command("TodoAdd", function(cmd_opts)
	require("todo").add_todo({ title = cmd_opts.args })
end, { nargs = "+" })
