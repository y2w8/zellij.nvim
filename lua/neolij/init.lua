local M = {}

local direction_translation = {
	up = "k",
	down = "j",
	left = "h",
	right = "l",
}
-- Run zellij action safely
function M.zellij_action(args)
	if not os.getenv("ZELLIJ") then
		return
	end
	vim.fn.system("zellij action " .. args)
	if vim.v.shell_error ~= 0 then
		error("zellij executable not found in PATH")
	end
end

-- Try vim window move, fallback to zellij
local function navigate(direction, vim_key, fallback_zellij, fallback_nvim)
	local before = vim.fn.winnr()
	vim.cmd("wincmd " .. vim_key)
	local after = vim.fn.winnr()

	-- If vim didn't move, fallback to zellij
	if before == after then
    if fallback_nvim then
      local current_tab = vim.fn.tabpagenr()
      local last_tab = vim.fn.tabpagenr("$")

      -- 2. Fallback to Tab switching based on direction
      -- We'll use 'l' (right) and 'h' (left) to trigger tab movement
      if direction == "right" and current_tab < last_tab then
        vim.cmd("tabnext")
        return
      elseif direction == "left" and current_tab > 1 then
        vim.cmd("tabprevious")
        return
      end

        -- If we reach here, neither window nor tab could move: escape to Zellij
        M.zellij_action(fallback_zellij .. " " .. direction)
    end
	end
end

-- Window navigation
function M.move(direction)
	navigate(direction, direction_translation[direction], "move-focus")
end

-- Window navigation or tab switch
function M.move_or_tab(direction, fallback_nvim)
	navigate(direction, direction_translation[direction], "move-focus-or-tab", fallback_nvim)
end

-- Tab actions
function M.new_tab(opts)
	if type(opts) == "table" then
		opts = opts.args
	end

	if opts ~= "" then
		M.zellij_action("new-tab " .. opts)
	else
		M.zellij_action("new-tab")
	end
end

function M.rename_tab(name)
	if type(name) == "table" then
		name = name.args
	end

	if name == "" or name == nil then
		name = vim.fn.input("Tab name: ")
	end

	if name == nil or name == "" then
		vim.notify("No tab name provided", vim.log.levels.ERROR)
		return
	end

	M.zellij_action("rename-tab " .. name)
end

function M.move_tab(direction)
	M.zellij_action("move-tab " .. direction)
end

-- Pane actions
function M.new_pane(opts)
	if type(opts) == "table" then
		opts = opts.args
	end

	if opts ~= "" then
		-- allow custom flags like -d right, -n name, etc
		M.zellij_action("new-pane " .. opts)
	else
		M.zellij_action("new-pane")
	end
end

function M.rename_pane(name)
	if type(name) == "table" then
		name = name.args
	end

	if name == "" or name == nil then
		name = vim.fn.input("Pane name: ")
	end

	if name == nil or name == "" then
		vim.notify("No pane name provided", vim.log.levels.ERROR)
		return
	end

	M.zellij_action("rename-pane " .. name)
end

function M.move_pane(direction)
	M.zellij_action("move-pane " .. direction)
end

-- Setup user commands
function M.setup()
	vim.api.nvim_create_user_command("NeolijUp", function()
		M.move("up")
	end, {})
	vim.api.nvim_create_user_command("NeolijDown", function()
		M.move("down")
	end, {})
	vim.api.nvim_create_user_command("NeolijLeft", function()
		M.move("left")
	end, {})
	vim.api.nvim_create_user_command("NeolijRight", function()
		M.move("right")
	end, {})

	vim.api.nvim_create_user_command("NeolijLeftTab", function()
		M.move_or_tab("left", false)
	end, {})
	vim.api.nvim_create_user_command("NeolijRightTab", function()
		M.move_or_tab("right", false)
	end, {})

	vim.api.nvim_create_user_command("NeolijLeftSmart", function()
		M.move_or_tab("left", true)
	end, {})
	vim.api.nvim_create_user_command("NeolijRightSmart", function()
		M.move_or_tab("right", true)
	end, {})

	vim.api.nvim_create_user_command("NeolijNewTab", M.new_tab, { nargs = "*" })
	vim.api.nvim_create_user_command("NeolijRenameTab", M.rename_tab, { nargs = "?" })
	vim.api.nvim_create_user_command("NeolijMoveTabRight", function()
		M.move_tab("right")
	end, {})
	vim.api.nvim_create_user_command("NeolijMoveTabLeft", function()
		M.move_tab("left")
	end, {})

	vim.api.nvim_create_user_command("NeolijNewPane", M.new_pane, { nargs = "*" })
	vim.api.nvim_create_user_command("NeolijRenamePane", M.rename_pane, { nargs = "?" })
	vim.api.nvim_create_user_command("NeolijMovePaneUp", function()
		M.move_pane("up")
	end, {})
	vim.api.nvim_create_user_command("NeolijMovePaneDown", function()
		M.move_pane("down")
	end, {})
	vim.api.nvim_create_user_command("NeolijMovePaneRight", function()
		M.move_pane("right")
	end, {})
	vim.api.nvim_create_user_command("NeolijMovePaneLeft", function()
		M.move_pane("left")
	end, {})
end

return M
