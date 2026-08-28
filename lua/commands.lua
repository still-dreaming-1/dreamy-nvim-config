vim.api.nvim_create_user_command(
    'ToggleMouse',
    function (params)
        if vim.o.mouse == '' then
            vim.o.mouse = 'a'
        else
            vim.o.mouse = ''
        end
    end,
    {}
)

local function create_change_directory_command(name, path)
    vim.api.nvim_create_user_command(
        name,
        function()
            vim.api.nvim_set_current_dir(vim.fn.expand(path))
        end,
        {}
    )
end

create_change_directory_command('Chome', '~')
create_change_directory_command('Cpack', '~/.local/share/nvim/site/pack/core/opt')
create_change_directory_command('Chiv', '~/.local/share/nvim/site/pack/core/opt/vim-elhiv')
create_change_directory_command('Cvim', '~/.config/nvim')
create_change_directory_command('Clua', '~/.config/nvim/lua')
create_change_directory_command('Csearch', '~/.local/share/nvim/site/pack/core/opt/vim-project-search')
create_change_directory_command('Ckit', '~/.config/kitty')
