local M = {}

function M.enforce_coroutine()
    local co = coroutine.running()
    assert(co, 'Must run inside a coroutine')
    return co
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

    vim.loop.spawn(cmd[1], {
        cwd = cmd.cwd,
        args = {unpack(cmd, 2)},
        stdio = {nil, stdout, stderr},
    }, function(exit_code)
        coroutine.resume(co, exit_code)
    end)

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
