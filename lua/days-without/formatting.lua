local M = {}

function M.box_lines(text, height)
    if height < 3 then
        height = 3
    elseif height % 2 == 0 then
        height = height + 1
    end
    local text_width = #text
    -- TODO: calculate it to make the box look nice
    local padding_before = 2
    local padding_after = 2

    local lines = {}

    lines[1] = '╔' .. string.rep('═', text_width + padding_before + padding_after) .. '╗'
    lines[(height + 1) / 2] = '║' .. string.rep(' ', padding_before) .. text .. string.rep(' ', padding_after) .. '║'
    lines[height] = '╚' .. string.rep('═', text_width + padding_before + padding_after) .. '╝'

    if 3 < height then
        local filler = '║' .. string.rep(' ', text_width + padding_before + padding_after) .. '║'
        for i = 2, height - 1 do
            if lines[i] == nil then
                lines[i] = filler
            end
        end
    end

    return lines
end

function M.billboard_lines(in_box, caption_lines)
    local lines = M.box_lines(tostring(in_box), #caption_lines)
    for i, caption_line in ipairs(caption_lines) do
        lines[i] = lines[i] .. ' ' .. caption_line
    end
    return lines
end

function M.calc_lines_dimensions(lines)
    local cols = 0
    for _, line in ipairs(lines) do
        local length = #line
        if cols < length then
            cols = length
        end
    end
    return {
        rows = #lines,
        cols = cols,
    }
end

return M
