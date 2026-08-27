local M = {}

local configured = false
local pointer_shape = nil

local function set_pointer_shape(shape)
    if pointer_shape == shape then
        return
    end

    pointer_shape = shape
    -- Kitty OSC 22 sets the mouse pointer shape; an empty shape restores the default.
    io.stdout:write('\27]22;' .. (shape or '') .. '\27\\')
    io.stdout:flush()
end

-- At the bottom-right corner of a split, Neovim treats the cell as either
-- part of the status line or part of the vertical separator depending on the
-- surrounding layout. Mirror that choice so the pointer shows the direction
-- in which Neovim will actually resize the windows.
local function statusline_continues_right(winid)
    local path = {}

    local function find_window(node)
        if node[1] == 'leaf' then
            return node[2] == winid
        end

        for index, child in ipairs(node[2]) do
            if find_window(child) then
                path[#path + 1] = {
                    kind = node[1],
                    index = index,
                    count = #node[2],
                }
                return true
            end
        end

        return false
    end

    if not find_window(vim.fn.winlayout()) then
        return false
    end

    -- The path is ordered from the window's nearest parent outward.
    for _, parent in ipairs(path) do
        if parent.index < parent.count then
            return parent.kind == 'row'
        end
    end

    return false
end

local function update_pointer_shape()
    if vim.o.mouse == '' then
        set_pointer_shape(nil)
        return
    end

    local mouse = vim.fn.getmousepos()
    if mouse.winid == 0 or not vim.api.nvim_win_is_valid(mouse.winid) then
        set_pointer_shape(nil)
        return
    end

    -- Floating-window borders are not draggable split separators.
    if vim.api.nvim_win_get_config(mouse.winid).relative ~= '' then
        set_pointer_shape(nil)
        return
    end

    local wininfo = vim.fn.getwininfo(mouse.winid)[1]
    if not wininfo then
        set_pointer_shape(nil)
        return
    end

    local on_statusline = wininfo.status_height == 1
        and mouse.winrow == vim.api.nvim_win_get_height(mouse.winid) + 1
    local on_separator = mouse.wincol == vim.api.nvim_win_get_width(mouse.winid) + 1

    if on_statusline and on_separator then
        if statusline_continues_right(mouse.winid) then
            on_separator = false
        else
            on_statusline = false
        end
    end

    if on_statusline then
        set_pointer_shape('ns-resize')
    elseif on_separator then
        set_pointer_shape('ew-resize')
    else
        set_pointer_shape(nil)
    end
end

local function sync_mouse_tracking()
    vim.o.mousemoveevent = vim.o.mouse ~= ''
    update_pointer_shape()
end

function M.setup()
    if configured or vim.env.TERM ~= 'xterm-kitty' or vim.uv.guess_handle(1) ~= 'tty' then
        return
    end
    configured = true

    local mouse_move = vim.keycode('<MouseMove>')
    local namespace = vim.api.nvim_create_namespace('kitty_mouse_pointer_shape')

    -- Observe mouse movement without claiming the <MouseMove> mapping, so a
    -- plugin remains free to map the event for its own behavior.
    vim.on_key(function(key, typed)
        if key == mouse_move or typed == mouse_move then
            update_pointer_shape()
        end
    end, namespace)

    local group = vim.api.nvim_create_augroup('KittyMousePointerShape', { clear = true })

    vim.api.nvim_create_autocmd('OptionSet', {
        group = group,
        pattern = 'mouse',
        callback = sync_mouse_tracking,
    })

    vim.api.nvim_create_autocmd({
        'FocusGained',
        'VimResume',
        'VimResized',
        'WinNew',
        'WinClosed',
        'WinResized',
    }, {
        group = group,
        callback = update_pointer_shape,
    })

    vim.api.nvim_create_autocmd({ 'FocusLost', 'VimLeavePre', 'VimSuspend' }, {
        group = group,
        callback = function()
            set_pointer_shape(nil)
        end,
    })

    sync_mouse_tracking()
end

return M
