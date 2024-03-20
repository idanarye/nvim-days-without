local M = {}

local util = require'days-without.util'

function M.detect_git(path)
    local touched_files = {}
    for _, filename in ipairs(util.run_shell_cmd { cwd = path, 'git', 'diff', '--name-only' }) do
        touched_files[filename] = true
    end
    for _, filename in ipairs(util.run_shell_cmd { cwd = path, 'git', 'diff', '--name-only', '--cached' }) do
        touched_files[filename] = true
    end

    local current_time = vim.loop.gettimeofday()
    local oldest

    if next(touched_files) then
        local co = util.enforce_coroutine()
        oldest = current_time

        for filename in pairs(touched_files) do
            vim.loop.fs_stat(vim.fs.normalize(path .. '/' .. filename), function(err, stat)
                assert(not err)
                touched_files[filename] = nil
                if stat.mtime.sec < oldest then
                    oldest = stat.mtime.sec
                end
                if next(touched_files) == nil then
                    coroutine.resume(co)
                end
            end)
        end
        coroutine.yield()
    else
        oldest = tonumber(util.run_shell_cmd { cwd = path, 'git', 'log', '-1', '--format=%ct' }[1])
    end

    return current_time - oldest
end

return M
