local vim_elhiv_src
local vim_project_search_src

if vim.g.dreamy_developer then
    vim_elhiv_src = 'git@github.com:still-dreaming-1/vim-elhiv.git'
    vim_project_search_src = 'git@github.com:still-dreaming-1/vim-project-search.git'
else
    vim_elhiv_src = 'https://github.com/still-dreaming-1/vim-elhiv.git'
    vim_project_search_src = 'https://github.com/still-dreaming-1/vim-project-search.git'
end

local treesitter_parsers = {
    'bash',
    'c_sharp',
    'css',
    'html',
    'javascript',
    'java',
    'json',
    'kotlin',
    'lua',
    'markdown',
    'php',
    'typescript',
    'vim',
    'vimdoc',
    'zsh',
}

local treesitter_group = vim.api.nvim_create_augroup('dreamy_treesitter', {
    clear = true,
})

vim.api.nvim_create_autocmd('PackChanged', {
    group = treesitter_group,
    callback = function(event)
        local plugin = event.data

        if plugin.spec.name == 'nvim-treesitter'
            and (plugin.kind == 'install' or plugin.kind == 'update')
        then
            if not plugin.active then
                vim.cmd.packadd('nvim-treesitter')
            end

            vim.cmd.TSUpdate()
        end
    end,
})

local plugins = {
    'https://github.com/jlanzarotta/bufexplorer',
    'https://github.com/terryma/vim-expand-region',
    'https://github.com/qpkorr/vim-bufkill',
    'https://github.com/tpope/vim-repeat',
    'https://github.com/tpope/vim-commentary',
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/jreybert/vimagit',
    -- vim-UT depends on lh-vim-lib.
    'https://github.com/LucHermitte/lh-vim-lib',
    'https://github.com/LucHermitte/vim-UT',
    -- Requires a Nerd Fontto display icons correctly
    'https://github.com/nvim-tree/nvim-web-devicons', -- optional file icons for nvim-tree and fzf-lua
    'https://github.com/nvim-tree/nvim-tree.lua',
    -- Requires fzf
    'https://github.com/ibhagwan/fzf-lua',
    -- Requires tree-sitter-cli 0.26.1 or newer to install parsers.
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
    {
        src = 'https://github.com/folke/tokyonight.nvim',
        version = vim.version.range('^4'),
    },
    -- vim-project-search depends on vim-elhiv, so keep these in this order.
    {
        src = vim_elhiv_src,
        version = 'develop',
    },
    {
        src = vim_project_search_src,
        version = 'develop',
    },
}

vim.pack.add(plugins)

require('tokyonight').setup({
    style = 'moon', -- 'storm', 'moon', 'night', or 'day'
})
vim.cmd.colorscheme('tokyonight')

require('nvim-tree').setup()

require('nvim-treesitter').install(treesitter_parsers)

vim.api.nvim_create_autocmd('FileType', {
    group = treesitter_group,
    callback = function(event)
        local language = vim.treesitter.language.get_lang(event.match)

        if vim.list_contains(treesitter_parsers, language)
            and vim.treesitter.language.add(language)
        then
            vim.treesitter.start(event.buf, language)
        end
    end,
})
