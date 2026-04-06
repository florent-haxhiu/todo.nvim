--- Test todo
vim.api.nvim_create_user_command("Todo", function()
	require("todo").todo()
end, {})
