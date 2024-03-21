local M = {}

local util = require'days-without.util'

---@class Billboard
---@field lines string[]
---@field pos {row: number, col: number}
---@field lines_dimensions {rows: number, cols: number}
---@field screen_dimensions {rows: number, cols: number}
---@field win number
local Billboard = {}

---@return Billboard
function M.make_billboard(lines)
    local billboard = setmetatable({}, {__index = Billboard})

    billboard:set_lines(lines)

    return billboard
end

function Billboard:set_lines(lines)
    self.lines = lines
    self.lines_dimensions = require'days-without.formatting'.calc_lines_dimensions(lines)
end

function Billboard:collect_screen_dimensions()
    util.run_in_main_loop(function()
        self.screen_dimensions = {
            rows = vim.o.lines,
            cols = vim.o.columns,
        }
        self.center_coord = {
            row = math.floor((self.screen_dimensions.rows - self.lines_dimensions.rows) / 2),
            col = math.floor((self.screen_dimensions.cols - self.lines_dimensions.cols) / 2),
        }
    end)
end

---@param pos {row: number, col: number}
function Billboard:show_at(pos)
    self.pos = pos
    if not self.screen_dimensions then
        self:collect_screen_dimensions()
    end

    local function calc_dimension(dimension, coord, max_size)
        if max_size - coord < dimension then
            dimension = max_size - coord
        end
        if dimension < 1 then
            dimension = 1
        end
        return dimension
    end

    local win_config = {
        relative = 'editor',
        row = self.pos.row,
        col = self.pos.col,
        width = calc_dimension(self.lines_dimensions.cols, self.pos.col, self.screen_dimensions.cols),
        height = calc_dimension(self.lines_dimensions.rows, self.pos.row, self.screen_dimensions.rows),
    }

    if not self.win then
        util.run_in_main_loop(function()
            self.buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(self.buf, 0, 1, true, self.lines)
            self.win = vim.api.nvim_open_win(self.buf, false, win_config)
            vim.api.nvim_win_set_option(self.win, 'wrap', false)
        end)
    else
        vim.api.nvim_win_set_config(self.win, win_config)
    end
end

function Billboard:close()
    vim.api.nvim_buf_delete(self.buf, {})
    self.buf = nil
    self.win = nil
end

function M.animate_billboard(lines)
    local co = util.enforce_coroutine()

    local billboard = M.make_billboard(lines)
    billboard:collect_screen_dimensions()
    local col = billboard.screen_dimensions.cols - 1
    local row = billboard.center_coord.row
    while billboard.center_coord.col < col do
        col = col - 1
        util.wait(10)
        billboard:show_at{row = row, col = col}
    end
    util.wait(2000)
    while row < billboard.screen_dimensions.rows do
        row = row + 1
        util.wait(20)
        billboard:show_at{row = row, col = col}
    end
    billboard:close()
end

return M
