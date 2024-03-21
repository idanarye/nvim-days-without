local M = {}

function M.launch_coroutine(dlg, ...)
    local co = coroutine.create(function(...)
        xpcall(dlg, function(err)
            if type(err) ~= 'string' then
                err = vim.inspect(err)
            end
            local traceback = debug.traceback(err, 2)
            traceback = string.gsub(traceback, '\t', string.rep(' ', 8))
            vim.notify(traceback, vim.log.levels.ERROR, {
                title = 'ERROR in a "Days Without" related coroutine'
            })
        end, ...)
    end)
    coroutine.resume(co, ...)
end

function M.enforce_coroutine()
    local co = coroutine.running()
    assert(co, 'Must run inside a coroutine')
    return co
end

function M.wait(ms)
    local co = M.enforce_coroutine()
    vim.defer_fn(function()
        coroutine.resume(co)
    end, ms)
    coroutine.yield()
end

function M.run_in_main_loop(dlg, ...)
    local co = coroutine.running()
    if co then
        vim.schedule(function(...)
            coroutine.resume(co, dlg(...))
        end, ...)
        return coroutine.yield()
    else
        return dlg(...)
    end
end

local function pipe_reader(pipe)
    local chunks = {}
    vim.loop.read_start(pipe, function(err, data)
        assert(not err)
        table.insert(chunks, data)
    end)
    return chunks
end

function M.run_shell_cmd(cmd)
    local co = M.enforce_coroutine()

    local stdout = vim.loop.new_pipe()
    local stderr = vim.loop.new_pipe()

    local handle, err = vim.loop.spawn(cmd[1], {
        cwd = vim.fn.fnamemodify(cmd.cwd, ':p'),
        args = {unpack(cmd, 2)},
        stdio = {nil, stdout, stderr},
    }, function(exit_code)
        coroutine.resume(co, exit_code)
    end)
    if not handle then
        error(err)
    end

    local out_chunks = pipe_reader(stdout)
    local err_chunks = pipe_reader(stderr)

    local exit_code = coroutine.yield()

    if exit_code == 0 then
        local result = vim.split(table.concat(out_chunks), '\n')
        local last_idx = #result
        if result[last_idx] == '' then
            result[last_idx] = nil
        end
        return result
    else
        error(table.concat(err_chunks))
    end
end

return M
