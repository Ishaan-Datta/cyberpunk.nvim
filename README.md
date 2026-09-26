# cyberpunk.nvim

A Neovim port of the `cyberpunk` VS Code theme by prometheux-ar.

The palette and token intent are mapped from the original VS Code theme into Neovim core highlights, Tree-sitter captures, LSP semantic tokens, diagnostics, diffs, Git signs, Telescope, completion menus, NvimTree/Neo-tree, WhichKey, Lazy, Mason, indent guides, and Markdown groups.

## lazy.nvim

```lua
{
  dir = vim.fn.stdpath('config') .. '/local/cyberpunk.nvim',
  name = 'cyberpunk.nvim',
  priority = 1000,
  config = function()
    vim.cmd.colorscheme('cyberpunk')
  end,
}
```

Or copy the plugin folder into any directory on your runtimepath and run:

```lua
vim.cmd.colorscheme('cyberpunk')
```

## Direct install into your config

Copy:

- `colors/cyberpunk.lua` to `~/.config/nvim/colors/cyberpunk.lua`
- `lua/cyberpunk/init.lua` to `~/.config/nvim/lua/cyberpunk/init.lua`

Then in `init.lua`:

```lua
vim.cmd.colorscheme('cyberpunk')
```

## Optional customization

```lua
require('cyberpunk').setup({
  on_highlights = function(hi, p)
    hi('CursorLine', { bg = '#100D23' })
  end,
})
```
