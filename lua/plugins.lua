local vim_elhiv_src

if vim.g.dreamy_developer then
    vim_elhiv_src = 'git@github.com:still-dreaming-1/vim-elhiv.git'
else
    vim_elhiv_src = 'https://github.com/still-dreaming-1/vim-elhiv.git'
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

-- nvim-treesitter's main branch requires tree-sitter-cli 0.26.1 or newer
-- to be installed separately before parsers can be installed.
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
    'https://github.com/nvim-tree/nvim-web-devicons', -- optional file icons for nvim-tree and fzf-lua
    'https://github.com/nvim-tree/nvim-tree.lua',
    'https://github.com/ibhagwan/fzf-lua',
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
    {
        src = vim_elhiv_src,
        version = 'develop',
    },
--[[
    use {
        'folke/tokyonight.nvim',
        branch = 'main',
    }
    if vim.g.dreamy_developer then
        use {
            'git@github.com:still-dreaming-1/vim-project-search.git',
            branch = 'develop',
            requires = {{
                'git@github.com:still-dreaming-1/vim-elhiv.git',
                branch = 'develop',
            }}
        }
    else
        use {
            'still-dreaming-1/vim-project-search',
            branch = 'develop',
            requires = {{
                'still-dreaming-1/vim-elhiv',
                branch = 'develop',
            }}
        }
    end
]]
}

vim.pack.add(plugins)

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
