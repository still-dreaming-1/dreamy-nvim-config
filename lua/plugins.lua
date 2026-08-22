local plugins = {
    'https://github.com/jlanzarotta/bufexplorer',
    'https://github.com/terryma/vim-expand-region',
    'https://github.com/qpkorr/vim-bufkill',
    'https://github.com/tpope/vim-repeat',
    'https://github.com/tpope/vim-commentary',
--[[
    if vim.g.dreamy_developer then
        use {
            'git@github.com:still-dreaming-1/vim-elhiv.git',
            branch = 'develop',
        }
    else
        use {
            'still-dreaming-1/vim-elhiv',
            branch = 'develop',
        }
    end
    if not vim.g.vscode then
        use 'neomake/neomake'
        use 'tpope/vim-fugitive'
        use 'jreybert/vimagit'
        use {
            'LucHermitte/vim-UT', -- unit testing
            requires = 'LucHermitte/lh-vim-lib'
        }
        use {
            'nvim-tree/nvim-tree.lua',
            requires = 'nvim-tree/nvim-web-devicons', -- optional, for file icons
            tag = 'nightly', -- nightly = stable...
        }
        use {
            'ibhagwan/fzf-lua',
            requires = 'nvim-tree/nvim-web-devicons',
        }
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
        }
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
    end
]]
}

vim.pack.add(plugins)
