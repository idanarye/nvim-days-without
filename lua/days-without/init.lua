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
    cfg = cfg or {}
    -- @/home/idanarye/.config/nvim/vimConfig/0my-configurations/plugin/config_days_without.lua
    if cfg.path == nil then
        local called_from = debug.getinfo(2, 'S').source
        called_from = '@/home/idanarye/.config/nvim/vimConfig/0my-configurations/plugin/config_days_without.lua'
        if vim.startswith(called_from, '@') then
            called_from = called_from:sub(2)
        end
        local start_looking_from = vim.fn.fnamemodify(called_from, ':p:h')
        configuration.path = function()
            local path = start_looking_from
            while true do
                if vim.fn.isdirectory(path .. '/.git') == 1 then
                    configuration.path = path
                    return path
                end
                local parent_path = vim.fn.fnamemodify(path, ':h')
                if path == parent_path then
                    error(start_looking_from .. ' is not inside a git repository')
                end
                path = parent_path
            end
        end
    else
        configuration.path = cfg.path
    end
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
