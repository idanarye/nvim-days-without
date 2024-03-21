local M = {}

local util = require'days-without.util'

function M.show(cfg)
    util.launch_coroutine(function()
        local seconds_without = require'days-without.detection'.detect_git(cfg.path)
        local days_without = math.floor(seconds_without / 3600 / 24)
        local billboard_lines = require'days-without.formatting'.billboard_lines(days_without, {
            '',
            '  DAYS      WITHOUT',
            '      modifying',
            "Neovim's configuration",
            '',
        })
        require'days-without.billboard'.animate_billboard(billboard_lines)
    end)
end

return M
