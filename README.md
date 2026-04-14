# Neolij.nvim
A lightweight Neovim plugin that integrates Neovim window navigation with [Zellij](https://zellij.dev/). If Neovim can’t move to another window, it automatically falls back to Zellij actions.
giving you seamless navigation between Neovim splits and Zellij panes/tabs
## Installing
### lazyvim
```lua
{
   "y2w8/neolij.nvim",
    event = "VeryLazy",
    opts = {}, -- Important even if empty
    keys = {
    -- Window navigation
    { "<C-k>", ":NeolijUp<CR>", mode = { "n", "t" }, desc = "Move up", silent = true  },
    { "<C-j>", ":NeolijDown<CR>", mode = { "n", "t" }, desc = "Move down", silent = true  },
    { "<C-h>", ":NeolijLeftTab<CR>", mode = { "n", "t" }, desc = "Move left", silent = true  },
    { "<C-l>", ":NeolijRightTab<CR>", mode = { "n", "t" }, desc = "Move right", silent = true  },

    -- Tab actions
    { "<leader>zt", ":NeolijNewTab<CR>", desc = "New Zellij Tab", silent = true  },
    { "<leader>zr", ":NeolijRenameTab<CR>", desc = "Rename Zellij Tab", silent = true  },
    { "<leader>zl", ":NeolijMoveTabLeft<CR>", desc = "Move Tab Left", silent = true  },
    { "<leader>zL", ":NeolijMoveTabRight<CR>", desc = "Move Tab Right", silent = true  },

    -- Pane actions
    { "<leader>zp", ":NeolijNewPane -d right<CR>", desc = "New Zellij Pane vertical", silent = true  },
    { "<leader>zP", ":NeolijNewPane -d down<CR>", desc = "New Zellij Pane horizontal", silent = true  },
    { "<leader>zf", ":NeolijNewPane -f<CR>", desc = "New Zellij Floating Pane", silent = true  },
    { "<leader>zn", ":NeolijRenamePane<CR>", desc = "Rename Zellij Pane", silent = true  },
    { "<leader>zu", ":NeolijMovePaneUp<CR>", desc = "Move Pane Up", silent = true  },
    { "<leader>zd", ":NeolijMovePaneDown<CR>", desc = "Move Pane Down", silent = true  },
    { "<leader>zh", ":NeolijMovePaneLeft<CR>", desc = "Move Pane Left", silent = true  },
    { "<leader>zR", ":NeolijMovePaneRight<CR>", desc = "Move Pane Right", silent = true  },
  },
}
```

### Zellij
```kdl

keybinds clear-defaults=true {
    shared_except "locked" {
        bind "Ctrl left" { MoveFocusOrTab "left"; }
        bind "Ctrl down" { MoveFocus "down"; }
        bind "Ctrl up" { MoveFocus "up"; }
        bind "Ctrl right" { MoveFocusOrTab "right"; }
    }
}

plugins {
    // Required
    autolock location="https://github.com/fresh2dev/zellij-autolock/releases/latest/download/zellij-autolock.wasm" {
        // Enabled at start?
        is_enabled true
        // Lock when any open these programs open.
        triggers "nvim|vim"
        // Reaction to input occurs after this many seconds. (default=0.3)
        // (An existing scheduled reaction prevents additional reactions.)
        reaction_seconds "0.3"
        // Print to Zellij log? (default=false)
        print_to_log false
    }
}

// Plugins to load in the background when a new session starts
load_plugins {
    autolock
}

```


## Commands
### Navigation
| Command | Function | Description |
| --------------- | --------------- | --------------- |
| `:NeolijUp` | require("neolij").move("up") | Move up |
| `:NeolijDown` | require("neolij").move("down") | Move down |
| `:NeolijLeft` | require("neolij").move("left") | Move left |
| `:NeolijRight` | require("neolij").move("right") | Move right |
| `:NeolijLeftTab` | require("neolij").move_or_tab("left", false) | Move left or switch tab (zellij tabs) |
| `:NeolijRightTab` | require("neolij").move_or_tab("right", false) | Move right or switch tab (zellij tabs) |
| `:NeolijLeftSmart` | require("neolij").move_or_tab("left", true) | Move left or switch tab (nvim tab or zellij tab) |
| `:NeolijRightSmart` | require("neolij").move_or_tab("right", true) | Move right or switch tab (nvim tab or zellij tab) |


### Tab Managment
> [!TIP]
> If `name` is not provided, you will be prompted for input.

> [!TIP]
> type this in the terminal to see possible arguments
> ```sh
> zellij action new-tab --help
> ```

| Command | Function | Description |
| --------------- | --------------- | --------------- |
| `:NeolijNewTab [args?]` | require("neolij").new_tab(args?) | Create new tab |
| `:NeolijRenameTab [name?]` | require("neolij").rename_tab(name?) | Rename current zellij tab  |
| `:NeolijMoveTabLeft` | require("neolij").move_tab("left") | Move tab left |
| `:NeolijMoveTabRight` | require("neolij").move_tab("right") | Move tab right |


### Pane Managment
> [!TIP]
> If `name` is not provided, you will be prompted for input. 

> [!TIP]
> type this in the terminal to see possible arguments
> ```sh
> zellij action new-pane --help
> ```

| Command | Function | Description |
| --------------- | --------------- | --------------- |
| `:NeolijNewPane [args?]` | require("neolij").new_pane(args?) | Create new pane |
| `:NeolijRenamePane [name?]` | require("neolij").rename_pane(name?) | Rename current zellij pane  |
| `:NeolijMovePaneUp` | require("neolij").move_pane("up") | Move pane up |
| `:NeolijMovePaneDown` | require("neolij").move_pane("down") | Move pane down |
| `:NeolijMovePaneLeft` | require("neolij").move_pane("left") | Move pane left |
| `:NeolijMovePaneRight` | require("neolij").move_pane("right") | Move pane right |

### Custom
You can run any zellij action using:
```lua
require("neolij").zellij_action("toggle-fullscreen")
```

> [!TIP]
> type this in terminal to see possible actions 
>```sh
>zellij action help
>```

#### Examples
##### Toggle fullscreen for the current zellij pane
```lua
require("neolij").zellij_action("toggle-fullscreen")
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

    require("neolij").new_pane({ args = args })
  end,
  { desc = "Neolij: New pane (ask direction & name)" }
)

```
