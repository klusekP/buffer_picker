# buffer_picker.nvim

A simple buffer picker for Neovim using Telescope.

## Requirements

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (for testing)

## Installation

With LazyVim/Lazy.nvim:

```lua
{ "klusekP/buffer_picker" }
```

## Usage

Press `<M-Tab>` to open buffer picker, then:
- Type to filter buffers
- Press `<Enter>` to select buffer
- Press `<Esc>` to close

## Keymap

| Key | Action |
|-----|--------|
| `<M-Tab>` | Open buffer picker |
| `<Enter>` | Select buffer |
| `<Esc>` | Close picker |

You can customize the keymap in your config:

```lua
require("buffer_picker").setup({
  keymap = "<leader>b"
})
```

## Testing

```bash
# Run tests with plenary
nvim --headless -u ./tests/minimal_init.lua -c "PlenaryBustedDirectory tests/ {minimal_init = './tests/minimal_init.lua'}"
```
