local M = {}

-- Modes
local MODE = {
  WINDOW = "window",
  TAB = "tab",
}

  local direction_translation = {
    up = "k",
    down = "j",
    left = "h",
    right = "l",
  }
-- Run zellij action safely
local function zellij_action(args)
  vim.fn.system("zellij action " .. args)
  if vim.v.shell_error ~= 0 then
    error("zellij executable not found in PATH")
  end
end

-- Try vim window move, fallback to zellij
local function navigate(direction, vim_key, fallback)
  local before = vim.fn.winnr()
  vim.cmd("wincmd " .. vim_key)
  local after = vim.fn.winnr()

  -- If vim didn't move, fallback to zellij
  if before == after then
    zellij_action(fallback .. " " .. direction)
  end
end

-- Window navigation
function M.move(direction)
  navigate(direction, direction_translation[direction], "move-focus")
end

-- Window navigation or tab switch
function M.move_or_tab(direction)
  navigate(direction, direction_translation[direction], "move-focus-or-tab")
end

-- Tab actions
function M.new_tab()
  zellij_action("new-tab")
end

function M.rename_tab()
  zellij_action("rename-tab")
end

function M.move_tab(direction)
  zellij_action("move-tab " .. direction)
end

-- Pane actions
function M.new_pane()
  zellij_action("new-pane")
end

function M.rename_pane()
  zellij_action("rename-pane")
end

function M.move_pane(direction)
  zellij_action("move-pane " .. direction)
end

-- Setup user commands
function M.setup()
  vim.api.nvim_create_user_command("ZellijUp", function() M.move("up") end, {})
  vim.api.nvim_create_user_command("ZellijDown", function() M.move("down") end, {})
  vim.api.nvim_create_user_command("ZellijLeft", function() M.move("left") end, {})
  vim.api.nvim_create_user_command("ZellijRight", function() M.move("right") end, {})

  vim.api.nvim_create_user_command("ZellijUpTab", function() M.move_or_tab("up") end, {})
  vim.api.nvim_create_user_command("ZellijDownTab", function() M.move_or_tab("down") end, {})
  vim.api.nvim_create_user_command("ZellijLeftTab", function() M.move_or_tab("left") end, {})
  vim.api.nvim_create_user_command("ZellijRightTab", function() M.move_or_tab("right") end, {})

  vim.api.nvim_create_user_command("ZellijNewTab", M.new_tab, {})
  vim.api.nvim_create_user_command("ZellijMoveTabRight", function() M.move_tab("right") end, {})
  vim.api.nvim_create_user_command("ZellijMoveTabLeft", function() M.move_tab("left") end, {})

  vim.api.nvim_create_user_command("ZellijNewPane", M.new_tab, {})
  vim.api.nvim_create_user_command("ZellijMovePaneUp", function() M.move_pane("up") end, {})
  vim.api.nvim_create_user_command("ZellijMovePaneDown", function() M.move_pane("down") end, {})
  vim.api.nvim_create_user_command("ZellijMovePaneRight", function() M.move_pane("right") end, {})
  vim.api.nvim_create_user_command("ZellijMovePaneLeft", function() M.move_pane("left") end, {})

end

return M
