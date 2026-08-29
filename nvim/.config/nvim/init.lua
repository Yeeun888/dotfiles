-- Kickstart n.position=right
-- NVIM based fork
-- TJ DeVries is the goat for that youtube video
-- Some comments are left in for future reference
-- Author @Maximus Chan

-- GLOBALS
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true -- Ensure JetBrains Mono Nerd Font installed

-- SETTINGS / OPTIONS

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "a" -- Enable mouse for all modes
vim.o.showmode = false -- Mode in status line no need to show

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.

-- See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Save history

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

vim.o.updatetime = 250 -- Update speed
vim.o.timeoutlen = 300 -- Mapped sequence time

vim.o.splitright = true -- Splits
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = "▏ ", trail = "·", nbsp = "␣" }

vim.o.inccommand = "split" -- Preview substitutions as typing

vim.o.cursorline = true -- Show horizontal cursor line and color
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#4f4e4e" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffd866" }) -- Monokai pro specific color

vim.o.scrolloff = 10 -- Number of lines to keep above the cursor
vim.o.confirm = true -- Ask to save file if unchanged
vim.o.relativenumber = true

-- KEYMAPS

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- LSP hover border
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Diagnostic Related Shits
vim.diagnostic.config({
	update_in_insert = false,
	signs = true,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },

	virtual_text = true, -- Error shows up at the end of the line
	virtual_lines = false, -- Error shows up underneath the line, with virtual lines

	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = { float = true },
})

-- Skill issue
vim.keymap.set("n", "<left>", '<cmd>echo "Skill issue use h"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Skill issue use j"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Skill issue use k"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Skill issue use l"<CR>')

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "H", "<cmd>bprev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bd", function()
	local buf = vim.api.nvim_get_current_buf()
	vim.cmd("bnext")
	vim.api.nvim_buf_delete(buf, {})
end, { desc = "Go to prev buffer and delete buffer" })

vim.keymap.set("n", "<leader>ow", "<cmd>edit ~/.wezterm.lua<CR>", { desc = "[O]pen [W]ezterm config" })
vim.keymap.set("n", "<leader>on", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[O]pen [N]eovim files" })

-- AUTO COMMANDS
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Update Neovim when making changes autocommand
local group = vim.api.nvim_create_augroup("Group", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = vim.fn.expand("~") .. "/.config/nvim/*",
	callback = function()
		for name, _ in pairs(package.loaded) do
			if name:match("^user") then
				-- clear the cache
				package.loaded[name] = nil
			end
		end

		-- source the init.lua file
		dofile(vim.env.MYVIMRC)
	end,
	group = group,
})

-- Show neo-tree keybindings in a floating window
vim.api.nvim_create_autocmd("FileType", {
	pattern = "neo-tree",
	callback = function(event)
		vim.keymap.set("n", "h", function()
			local lines = {
				" Neo-tree Keybindings",
				"",
				" Navigation",
				"  <         Prev source",
				"  >         Next source",
				"  <BS>      Navigate up",
				"  .         Set root",
				"  [g        Prev git modified",
				"  ]g        Next git modified",
				"",
				" Open / Close",
				"  <Space>   Toggle node",
				"  <CR>      Open",
				"  C         Close node",
				"  z         Close all nodes",
				"  S         Open split",
				"  s         Open vsplit",
				"  t         Open in new tab",
				"  w         Open with window picker",
				"",
				" Preview",
				"  P         Toggle preview",
				"  l         Focus preview",
				"  <C-f>     Scroll preview down",
				"  <C-b>     Scroll preview up",
				"  <Esc>     Revert preview",
			}

			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.bo[buf].modifiable = false

			local width = 36
			local height = #lines
			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				col = math.floor((vim.o.columns - width) / 2),
				row = math.floor((vim.o.lines - height) / 2),
				style = "minimal",
				border = "rounded",
				title = " ? Help ",
				title_pos = "center",
			})

			local function close()
				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end
			end

			-- Close on q, Esc, or leaving the window
			vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
			vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
			vim.api.nvim_create_autocmd("WinLeave", { buffer = buf, once = true, callback = close })
		end, { buffer = event.buf, desc = "Show neo-tree keybindings" })
	end,
})

-- Toggle relative numbers: on in normal/visual, off in other modes
vim.api.nvim_create_autocmd("InsertEnter", { command = [[set norelativenumber]] })
vim.api.nvim_create_autocmd("InsertLeave", { command = [[set relativenumber]] })

vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:[Vvx\x16]*",
	command = [[set relativenumber]],
})

-- LAZYVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

-- idk what this is tbh
---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- PLUGINS
require("lazy").setup({
	-- Guess indent of the files
	{ "NMAC427/guess-indent.nvim", opts = {} },

	{ -- Add gitsigns to gutter
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- Banger borders for diagnostic windows
		"folke/noice.nvim",
		enabled = true,
		event = "VeryLazy",
		opts = {
			preset = {
				command_palette = false,
			},
		},

		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = {
					stages = "static",
				},
			},
		},
	},

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = { mappings = vim.g.have_nerd_font },
			preset = "helix",

			win = {
				border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
			},

			-- Document existing key chains
			spec = {
				{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				{ "<leader>x", group = "Diagnostics" },
				{ "<leader>o", group = "[O]pen" },
				{ "<leader>b", group = "[B]uffer" },
				{ "<leader>c", group = "Goto [C]ode" },
			},
		},
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		enabled = true,
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			-- The easiest way to use Telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			require("telescope").setup({
				-- Additional telescope settings can be added here
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
			-- it is better explained there). This allows easily switching between pickers if you prefer using something else!
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
				callback = function(event)
					local buf = event.buf

					-- Find references for the word under your cursor.
					vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })

					-- Jump to the implementation of the word under your cursor.
					-- Useful when your language has ways of declaring types without an actual implementation.
					vim.keymap.set(
						"n",
						"gri",
						builtin.lsp_implementations,
						{ buffer = buf, desc = "[G]oto [I]mplementation" }
					)

					-- Jump to the definition of the word under your cursor.
					-- This is where a variable was first declared, or where a function is defined, etc.
					-- To jump back, press <C-t>.
					vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })

					-- Fuzzy find all the symbols in your current document.
					-- Symbols are things like variables, functions, types, etc.
					vim.keymap.set(
						"n",
						"gO",
						builtin.lsp_document_symbols,
						{ buffer = buf, desc = "Open Document Symbols" }
					)

					-- Fuzzy find all the symbols in your current workspace.
					-- Similar to document symbols, except searches over your entire project.
					vim.keymap.set(
						"n",
						"gW",
						builtin.lsp_dynamic_workspace_symbols,
						{ buffer = buf, desc = "Open Workspace Symbols" }
					)

					-- Jump to the type of the word under your cursor.
					-- Useful when you're not sure what type a variable is and you want to see
					-- the definition of its *type*, not where it was *defined*.
					vim.keymap.set(
						"n",
						"grt",
						builtin.lsp_type_definitions,
						{ buffer = buf, desc = "[G]oto [T]ype Definition" }
					)
				end,
			})

			-- Override default behavior and theme when searching
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			vim.keymap.set("n", "<leader>sn", function()
				require("telescope").extensions.notify.notify()
			end, { desc = "[S]earch [N]otifications" })

			vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })
		end,
	},

	-- LSP Plugins
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "mason-org/mason.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},

		-- LSP ATTACH SETTINGS
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- When cursor says, highlight happens
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- Inlay hints e.g. the type or name of the parameter
					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Languages servers / formatters etc
			local servers = {
				-- LSP
				clangd = {},
				gopls = {},
				pyright = {},
				ts_ls = {},
			}

			-- Ensure the servers and tools above are installed with mason (:mason)
			-- NOTE: Mason package names (kebab-case) differ from vim.lsp server names (snake_case)
			-- wtf claude code fix btw gg
			local ensure_installed = {
				"lua-language-server",
				"stylua",
				"clangd",
				"gopls",
				"pyright",
				"typescript-language-server",
			}

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- LSP Config for other languages
			for name, server in pairs(servers) do
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end

			-- LSP Config for just Lua recommended by NEOVIM
			-- Apply LSP Config for VIM only when on NEOVIM settings as detected below
			vim.lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and path ~= vim.fn.expand("~/dotfiles")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
							path = { "lua/?.lua", "lua/?/init.lua" },
						},
						diagnostics = {
							globals = { "vim", "require" },
						},
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
					})
				end,
			})
			vim.lsp.enable("lua_ls")
		end,
	},

	{ -- FORMATTER / Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = true,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},

	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				opts = {},
			},
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- :help ins-completion
				--
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				preset = "default",
			},

			appearance = {
				-- Keep mono if using nerd font
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets" },
			},

			snippets = { preset = "luasnip" },

			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},

	-- For rust only
	{
		"mrcjkb/rustaceanvim",
		version = "^8", -- Recommended
		lazy = false, -- This plugin is already lazy
	},

	-- Theme for neovim
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("monokai-pro").setup({
				transparent_background = false,
			})
			vim.cmd.colorscheme("monokai-pro")
		end,
	},

	-- Extra theme for light mode
	{
		"yorik1984/newpaper.nvim",
		config = function()
			require("lazy").setup({
				"yorik1984/newpaper.nvim",
				priority = 1000,
				config = true,
			})
		end,
	},

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules
		"nvim-mini/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			require("mini.files").setup({
				vim.keymap.set("n", "<leader>m", "<cmd>lua MiniFiles.open()<CR>", { desc = "Open mini file explorer" }),
			})
			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- ... and there is more!
			--  Check out: https://github.com/nvim-mini/mini.nvim
		end,
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		config = function()
			local filetypes = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			}

			require("nvim-treesitter").install(filetypes)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetypes,
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},

	-- File explorer for neovim
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			window = {
				width = math.floor(vim.o.columns * 0.2),
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
			vim.keymap.set("n", "<leader>e", ":Neotree<CR>")
		end,
	},

	-- Autopairs for brackets
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},

	-- Trouble and LSP diagnostics
	{
		"folke/trouble.nvim",
		opts = {
			win = {
				position = "right",
				size = { width = 0.25 },
				wo = { wrap = true },
			},
		},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle win.position=right<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cr",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	-- Status Bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				globalstatus = true,
				theme = "monokai-pro",
			},
		},
	},

	-- Open buffers line
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {},
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

local function set_custom_highlights()
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffd866" }) -- Monokai pro specific color
	vim.api.nvim_set_hl(0, "NoicePopupBorder", { fg = "#ffd866" })
	vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#ffd866" })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffd866" })
	vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#ffd866" })
	vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = "#ffd866", bg = "#403e41" })
end

-- Apply after colorscheme loads and again after VeryLazy plugins load
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_custom_highlights })
vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", callback = set_custom_highlights })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
