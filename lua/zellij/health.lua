local health = vim.health or require("health")

health.start("zellij.nvim")

-- Neovim version check
if vim.fn.has("nvim-0.9") == 1 then
	health.ok("Neovim version >= 0.9")
else
	health.error("Neovim 0.9+ is required")
end

-- Zellij executable check
if vim.fn.executable("zellij") == 1 then
	health.ok("zellij found in PATH")
else
	health.error("zellij not found in PATH")
end

-- check if inside zellij session
if vim.env.ZELLIJ then
	health.ok("Running inside Zellij session")
else
	health.warn("Not running inside Zellij (plugin will still load, but actions will fail)")
end
