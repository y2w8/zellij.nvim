# zellij.nvim
---
A lightweight Neovim plugin that integrates Neovim window navigation with [Zellij](https://zellij.dev/). If Neovim can’t move to another window, it automatically falls back to Zellij actions.
## Installing
### lazyvim
```lua
{
   "y2w8/zellij.nvim",
    event = "VeryLazy",
    opts = {}, -- Important even if empty
    keys = {
    -- Window navigation
    { "<C-k>", ":ZellijUp<CR>", desc = "Move up" },
    { "<C-j>", ":ZellijDown<CR>", desc = "Move down" },
    { "<C-h>", ":ZellijLeftTab<CR>", desc = "Move left" },
    { "<C-l>", ":ZellijRightTab<CR>", desc = "Move right" },

    -- Tab actions
    { "<leader>zt", ":ZellijNewTab<CR>", desc = "New Zellij Tab" },
    { "<leader>zr", ":ZellijRenameTab<CR>", desc = "Rename Zellij Tab" },
    { "<leader>zl", ":ZellijMoveTabLeft<CR>", desc = "Move Tab Left" },
    { "<leader>zL", ":ZellijMoveTabRight<CR>", desc = "Move Tab Right" },

    -- Pane actions
    { "<leader>zp", ":ZellijNewPane<CR>", desc = "New Zellij Pane" },
    { "<leader>zn", ":ZellijRenamePane<CR>", desc = "Rename Zellij Pane" },
    { "<leader>zu", ":ZellijMovePaneUp<CR>", desc = "Move Pane Up" },
    { "<leader>zd", ":ZellijMovePaneDown<CR>", desc = "Move Pane Down" },
    { "<leader>zh", ":ZellijMovePaneLeft<CR>", desc = "Move Pane Left" },
    { "<leader>zR", ":ZellijMovePaneRight<CR>", desc = "Move Pane Right" },
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
| `:ZellijLeftTab` | require("zellij").move_or_tab("left") | Move left or switch tab |
| `:ZellijRightTab` | require("zellij").move_or_tab("right") | Move right or switch tab |


### Tab Managment
> [!TIP]
> If `name` is not provided, you will be prompted for input. 

| Command | Function | Description |
| --------------- | --------------- | --------------- |
| `:ZellijNewTab` | require("zellij").new_tab() | Create new tab |
| `:ZellijRenameTab [name?]` | require("zellij").rename_tab(name?) | Rename current zellij tab  |
| `:ZellijMoveTabLeft` | require("zellij").move_tab("left") | Move tab left |
| `:ZellijMoveTabRight` | require("zellij").move_tab("right") | Move tab right |


### Pane Managment
> [!TIP]
> If `name` is not provided, you will be prompted for input. 

| Command | Function | Description |
| --------------- | --------------- | --------------- |
| `:ZellijNewPane` | require("zellij").new_pane() | Create new pane |
| `:ZellijRenamePane [name?]` | require("zellij").rename_pane({ name? }) | Rename current zellij pane  |
| `:ZellijMovePaneUp` | require("zellij").move_pane("up") | Move pane up |
| `:ZellijMovePaneDown` | require("zellij").move_pane("down") | Move pane down |
| `:ZellijMovePaneLeft` | require("zellij").move_pane("left") | Move pane left |
| `:ZellijMovePaneRight` | require("zellij").move_pane("right") | Move pane right |

### Custom
> [!TIP]
> type this in terminal to see possible action 
>```sh
>zellij action help
>```

```lua
require("zellij").zellij_action("toggle-fullscreen")
```
