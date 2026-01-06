# Keybinding Guide

This Neovim config follows a few conventions so new mappings stay predictable.

## General Principles

- **Plain keys** tweak core editor motions (`j`/`k` for wrapped movement, `<A-j>/<A-k>` to move lines).
- **`<leader>`** is the global prefix. Each following letter names a feature area (see table below).
- **`<localleader>`** is reserved for buffer‑local tools that are only relevant in specific filetypes (e.g. Quarto/Molten runners, Python test helpers). Keep those bindings next to the ftplugin that needs them.
- Prefer descriptive `desc` strings in the form `"[<Hint>] Meaning"` so which-key stays readable.

## `<leader>` Namespaces

| Prefix       | Purpose / Examples                                            |
| ------------ | ------------------------------------------------------------- |
| `<leader>c`  | Code actions: LSP rename, format, lint, Treesitter peeks.     |
| `<leader>d`  | Database tooling (Dadbod, dbee).                              |
| `<leader>f`  | Files & buffers: Telescope file pickers, Mini.files, Oil.     |
| `<leader>g`  | Git integrations including LazyGit.                           |
| `<leader>n`  | Neovim settings (`<leader>nr` redraw, `<leader>ni` inspect).  |
| `<leader>p`  | Paste/Image utilities (`<leader>pi`).                         |
| `<leader>q`  | Quit/session management.                                      |
| `<leader>r`  | Run & debug flows (DAP, language test runners).               |
| `<leader>s`  | Search interfaces (all Telescope pickers).                    |
| `<leader>u`  | Undo history (`telescope-undo`).                              |
| `<leader>w`  | Workspace helpers (cwd, window management).                   |
| `<leader>x`  | Diagnostics & quickfix dashboards (Trouble, lists).           |
| `<leader>X`  | Xcode/Swift project automation.                               |

When adding a new mapping, place it in the namespace that matches its behaviour. If nothing fits, consider whether the feature is buffer-local (`<localleader>`) or if you should introduce a new namespace with a matching which-key entry.

