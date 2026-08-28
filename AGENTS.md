# Repository Instructions

## Neovim option API

- Use `vim.o` for ordinary option reads and complete assignments.
- Use `vim.opt` only when its option-object behavior is needed, such as
  `:get()`, `:append()`, `:prepend()`, `:remove()`, or structured list/map
  values.
- Do not use `vim.opt` for a complete assignment when `vim.o` expresses the
  same operation directly.

```lua
vim.o.clipboard = 'unnamedplus'
vim.o.tabstop = 4

vim.opt.wildignore:append({ '*.pyc', 'node_modules' })
vim.opt.listchars = { tab = '>-', trail = '·' }
```
