# todo.nvim

A simple todo manager for Neovim. Todos are stored per project in a `todos.json` file at the git root (or current working directory if not in a git repo).

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "florent-haxhiu/todo.nvim",
    config = function()
        require("todo").setup()
    end
}
```

## Usage

Open the todo window with:

```
:Todo
```

### Keymaps

| Key     | Action          |
|---------|-----------------|
| `a`     | Add a new todo  |
| `<CR>`  | Complete a todo |
| `d`     | Remove a todo   |

## Storage

Todos are saved to `todos.json` at the root of your git repository, making them project-local and committable to version control.
