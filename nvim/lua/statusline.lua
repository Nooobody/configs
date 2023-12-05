require('eviline')
--
-- local galaxy = require('galaxyline')
-- local colors = require('galaxyline.theme').default
-- local lspclient = require('galaxyline.provider_lsp')
--
-- -- condition.check_git_workspace() to find git root
-- local condition = require('galaxyline.condition') 
--
-- --[[
-- --  For left section:
-- --  - Filename
-- --  - Filepath?
-- --  - Filetype
-- --  - Current line and column
-- --  - Percentage of scroll
-- --]]
--
-- local gsl = function(value) table.insert(galaxy.section.left, value) end
--
-- gsl {
--   FileType = {
--     provider = 'FileIcon',
--     icon = ' ',
--     separator = '',
--     condition = function() return true end,
--     highlight = { colors.darkblue, colors.green },
--   }
-- }
--
-- gsl {
--   FileName = {
--     provider = 'FileName',
--     condition = function() return true end,
--     highlight = { colors.darkblue, colors.green },
--     separator = '',
--     separator_highlight = { colors.green, colors.bg }
--   },
-- }
--
-- --[[
-- --  For right section:
-- --  - Git branch
-- --  - Amount of added/modified/removed
-- --  - LSP client
-- --]]
--
-- local gsr = function(value) table.insert(galaxy.section.right, value) end
--
-- gsr {
--   GitBranch = {
--     provider = 'GitBranch',
--     condition = function() return condition.check_git_workspace() end,
--     highlight = { colors.orange, colors.red }
--   }
-- }