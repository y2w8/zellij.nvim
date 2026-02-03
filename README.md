# zellij.nvim
A lightweight Neovim plugin that integrates Neovim window navigation with [Zellij](https://zellij.dev/). If Neovim can’t move to another window, it automatically falls back to Zellij actions.
giving you seamless navigation between Neovim splits and Zellij panes/tabs
## Installing
### lazyvim
```lua
{
   "y2w8/zellij.nvim",
    event = "VeryLazy",
    opts = {}, -- Important even if empty
    keys = {
    -- Window navigation
    { "<C-k>", ":ZellijUp<CR>", mode = { "n", "t" }, desc = "Move up", silent = true  },
    { "<C-j>", ":ZellijDown<CR>", mode = { "n", "t" }, desc = "Move down", silent = true  },
    { "<C-h>", ":ZellijLeftTab<CR>", mode = { "n", "t" }, desc = "Move left", silent = true  },
    { "<C-l>", ":ZellijRightTab<CR>", mode = { "n", "t" }, desc = "Move right", silent = true  },

    -- Tab actions
    { "<leader>zt", ":ZellijNewTab<CR>", desc = "New Zellij Tab", silent = true  },
    { "<leader>zr", ":ZellijRenameTab<CR>", desc = "Rename Zellij Tab", silent = true  },
    { "<leader>zl", ":ZellijMoveTabLeft<CR>", desc = "Move Tab Left", silent = true  },
    { "<leader>zL", ":ZellijMoveTabRight<CR>", desc = "Move Tab Right", silent = true  },

    -- Pane actions
    { "<leader>zp", ":ZellijNewPane -d right<CR>", desc = "New Zellij Pane vertical", silent = true  },
    { "<leader>zP", ":ZellijNewPane -d down<CR>", desc = "New Zellij Pane horizontal", silent = true  },
    { "<leader>zf", ":ZellijNewPane -f<CR>", desc = "New Zellij Floating Pane", silent = true  },
    { "<leader>zn", ":ZellijRenamePane<CR>", desc = "Rename Zellij Pane", silent = true  },
    { "<leader>zu", ":ZellijMovePaneUp<CR>", desc = "Move Pane Up", silent = true  },
    { "<leader>zd", ":ZellijMovePaneDown<CR>", desc = "Move Pane Down", silent = true  },
    { "<leader>zh", ":ZellijMovePaneLeft<CR>", desc = "Move Pane Left", silent = true  },
    { "<leader>zR", ":ZellijMovePaneRight<CR>", desc = "Move Pane Right", silent = true  },
  },
}
```
## Commands
### Navigation
| Command | Function | Description |
| --------------- | --------------- | --------------- |
| `:ZellijUp` | require("zellij").move("up") | Move up |
| `:ZellijDown` | require("zellij").move("down") | Move down |
| `:ZellijLeft` | require("zellij").move("left") | Move left |
| `:ZellijRight` | require("zellij").move("right") | Move right |
| `:ZellijLeftTab` | require("zellij").move_or_tab("left", false) | Move left or switch tab (zellij tabs) |
| `:ZellijRightTab` | require("zellij").move_or_tab("right", false) | Move right or switch tab (zellij tabs) |
| `:ZellijLeftSmart` | require("zellij").move_or_tab("left", true) | Move left or switch tab (nvim tab or zellij tab) |
| `:ZellijRightSmart` | require("zellij").move_or_tab("right", true) | Move right or switch tab (nvim tab or zellij tab) |


### Tab Managment
> [!TIP]
> If `name` is not provided, you will be prompted for input.
> type this in the terminal to see options
> ```sh
> zellij action new-tab --help
> ```

| Command | Function | Description |
| --------------- | --------------- | --------------- |
| `:ZellijNewTab [args?]` | require("zellij").new_tab(args?) | Create new tab |
| `:ZellijRenameTab [name?]` | require("zellij").rename_tab(name?) | Rename current zellij tab  |
| `:ZellijMoveTabLeft` | require("zellij").move_tab("left") | Move tab left |
| `:ZellijMoveTabRight` | require("zellij").move_tab("right") | Move tab right |


### Pane Managment
> [!TIP]
> If `name` is not provided, you will be prompted for input. 
> type this in the terminal to see options
> ```sh
> zellij action new-pane --help
> ```

| Command | Function | Description |
| --------------- | --------------- | --------------- |
| `:ZellijNewPane [args?]` | require("zellij").new_pane(args?) | Create new pane |
| `:ZellijRenamePane [name?]` | require("zellij").rename_pane(name?) | Rename current zellij pane  |
| `:ZellijMovePaneUp` | require("zellij").move_pane("up") | Move pane up |
| `:ZellijMovePaneDown` | require("zellij").move_pane("down") | Move pane down |
| `:ZellijMovePaneLeft` | require("zellij").move_pane("left") | Move pane left |
| `:ZellijMovePaneRight` | require("zellij").move_pane("right") | Move pane right |

### Custom
You can run any zellij action using:
```lua
require("zellij").zellij_action("toggle-fullscreen")
```

> [!TIP]
> type this in terminal to see possible action 
>```sh
>zellij action help
>```

#### Examples
##### Toggle fullscreen for the current zellij pane
```lua
require("zellij").zellij_action("toggle-fullscreen")
```

##### Create a pane while asking for direction and name:
```lua

vim.keymap.set(
  "n",
  "<leader>zP",
  function()
    local dir = vim.fn.input("Direction (up/down/left/right): ")
    if dir == "" then
      -- default direction 
      dir = "right"
    end

    local name = vim.fn.input("Pane name: ")

    if name == "" then
      -- default name 
      name = "Pane"
    end

    local args = "-d " .. dir
    if name ~= "" then
      args = args .. " -n " .. name
    end

    require("zellij").new_pane({ args = args })
  end,
  { desc = "Zellij: New pane (ask direction & name)" }
)

```
