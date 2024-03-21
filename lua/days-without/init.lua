local M = {}

---@class DaysWithoutConfiguration
---@field path string?,
---@field caption string[]?,
---@field show_on_startup boolean?
local DaysWithoutConfiguration = {}

local configuration = {
    path = nil,
    caption = {
        '',
        '  DAYS      WITHOUT',
        '      modifying',
        "Neovim's configuration",
        '',
    }
}

---@param cfg DaysWithoutConfiguration
function M.setup(cfg)
    configuration.path = cfg.path
    if cfg.caption then
        if type(cfg.caption) == 'string' then
            configuration.caption = vim.split(cfg.caption, '\n')
        else
            configuration.caption = cfg.caption
        end
    end
    if cfg.show_on_startup == nil or cfg.show_on_startup then
        M.show()
    end
end

local util = require'days-without.util'

function M.show(cfg)
    cfg = cfg or {}
    util.launch_coroutine(function()
        local seconds_without = require'days-without.detection'.detect_git(cfg.path or configuration.path)
        local days_without = math.floor(seconds_without / 3600 / 24)
        local billboard_lines = require'days-without.formatting'.billboard_lines(days_without, cfg.caption or configuration.caption)
        require'days-without.billboard'.animate_billboard(billboard_lines)
    end)
end

return M
