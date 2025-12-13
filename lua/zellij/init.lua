local M = {}

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

local function zellij_action(args)
  vim.fn.system("zellij action " .. args)
  if vim.v.shell_error ~= 0 then
    error("zellij executable not found in PATH")
  end
end

local function navigate(direction, vim_key, fallback)
  local before = vim.fn.winnr()
  vim.cmd("wincmd " .. vim_key)
  local after = vim.fn.winnr()

  if before == after then
    zellij_action(fallback .. " " .. direction)
  end
end

function M.move(direction)
  navigate(direction, direction_translation[direction], "move-focus")
end

function M.move_or_tab(direction)
  navigate(direction, direction_translation[direction], "move-focus-or-tab")
end

function M.setup()
  vim.api.nvim_create_user_command("ZellijUp", function() M.move("up") end, {})
  vim.api.nvim_create_user_command("ZellijDown", function() M.move("down") end, {})
  vim.api.nvim_create_user_command("ZellijLeft", function() M.move("left") end, {})
  vim.api.nvim_create_user_command("ZellijRight", function() M.move("right") end, {})

  vim.api.nvim_create_user_command("ZellijUpTab", function() M.move_or_tab("up") end, {})
  vim.api.nvim_create_user_command("ZellijDownTab", function() M.move_or_tab("down") end, {})
  vim.api.nvim_create_user_command("ZellijLeftTab", function() M.move_or_tab("left") end, {})
  vim.api.nvim_create_user_command("ZellijRightTab", function() M.move_or_tab("right") end, {})
end

return M
