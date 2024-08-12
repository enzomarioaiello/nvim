# Neovim Shortcuts

This README file provides a comprehensive guide to various Neovim shortcuts and their functionalities. It is organized by mode and categories to help you understand and efficiently use the commands in your workflow.

## Table of Contents

- [Normal Mode](#normal-mode)
  - [Harpoon](#harpoon)
  - [LSP-Zero](#lsp-zero)
  - [Telescope](#telescope)
  - [Toggle Term](#toggle-term)
  - [Lazy Git](#lazy-git)
  - [Undo Tree](#undo-tree)
  - [Window Management](#window-management)
  - [Scrolling and Navigation](#scrolling-and-navigation)
  - [Copy and Paste](#copy-and-paste)
  - [Git Integration](#git-integration)
- [Visual Mode](#visual-mode)
  - [Copy and Paste](#copy-and-paste-visual)
  - [Line Movement](#line-movement)
  - [Highlighting](#highlighting)
- [Basic Vim Movement Commands](#basic-vim-movement-commands)
- [Additional Commands](#additional-commands)
  - [File Execution](#file-execution)
- [TMUX]

## Normal Mode

### Harpoon

- **Add current file to list:** `Space + a`
  - Adds the current file to the Harpoon list, which acts as a quick access list for frequently used files.

- **Toggle harpoon menu:** `Ctrl + e`
  - Opens and closes the Harpoon menu, allowing you to view and select from your list of marked files.

- **Move to file at a specific number on Harpoon list:**
  - `Ctrl + h` (File 1)
  - `Ctrl + t` (File 2)
  - `Ctrl + n` (File 3)
  - `Ctrl + s` (File 4)
  - Quickly jump to a specific file in the Harpoon list using these shortcuts.

### LSP-Zero

- **Move to next suggestion:** `Ctrl + n`
  - Navigate to the next suggestion in the autocomplete list.

- **Move to previous suggestion:** `Ctrl + p`
  - Navigate to the previous suggestion in the autocomplete list.

- **Select suggestion:** `Ctrl + y`
  - Confirm and insert the currently highlighted suggestion.

- **Display info over what you’re hovering:** `Shift + k`
  - Shows detailed information about the symbol or function currently under the cursor.

- **Search workspace for specific keyword:** `Space + v + w + s`
  - Initiates a search across the entire workspace for a given keyword.

- **Rename all instances of the symbol you're hovering:** `Space + v + r + n`
  - Renames all occurrences of the symbol under the cursor within the workspace.

### Telescope

- **Grep:** `Space + p + s`
  - Opens the Grep search, allowing you to search for text patterns across your project.

- **Open find files:** `Space + p + f`
  - Opens a file search dialog, making it easy to locate and open files by name.

- **Open find git:** `Ctrl + p`
  - Searches for files specifically tracked by Git.

### Toggle Term

- **Open terminal:** `Ctrl + \`
  - Opens an embedded terminal within Neovim, useful for running shell commands without leaving the editor.

### Lazy Git

- **Open lazy git:** `Space + l + g`
  - Opens the LazyGit interface, a terminal UI for Git operations.

- **Scroll up/down in main window:** `Shift + k/j`
  - Scrolls up or down within the LazyGit main window.

- **Move between tabs in the windows on the left:** `[` or `]`
  - Navigates between different tabs in the LazyGit interface.

### Undo Tree

- **Open undo tree:** `Space + u`
  - Opens the Undo Tree, a visual representation of your editing history.

### Window Management

- **Open new window:** `Ctrl + v + w`
  - Splits the current window vertically.

- **Move between windows:** `Ctrl + w + w`
  - Cycles between open windows.

### Scrolling and Navigation

- **Up (20 lines):** `Ctrl + u`
  - Scrolls up 20 lines.

- **Down (20 lines):** `Ctrl + d`
  - Scrolls down 20 lines.

- **Brings the next line up to current line:** `Shift + j`
  - Joins the line below with the current line.

- **Go back page:** `Space + p + v`
  - Navigates to the previous page.

### Copy and Paste

- **Copy:** `y`
  - Copies the selected text.

- **Highlight entire word:** `y + i + w`
  - Selects the entire word under the cursor and copies it.

- **Copy into clipboard:** `Space + y`
  - Copies the selected text into the system clipboard.

- **Paste below:** `Space + e + e`
  - Inserts the following template below the current line:
    ```go
    if err != nil {
      return err
    }
    ```

### Git Integration

- **Open git menu:** `Space + g + s`
  - Opens the Git status menu.

## Visual Mode

### Copy and Paste <a name="copy-and-paste-visual"></a>

- **Copy:** `y`
  - Copies the selected text.

- **Copy into clipboard:** `Space + y`
  - Copies the selected text into the system clipboard.

- **Paste:** `p`
  - If pasted at the cursor then it will not be overwritten but if pasted over a selection then it will be overwritten.

- **Paste over selection without overwriting clipboard:** `Space + p`
  - Pastes the clipboard content over the current selection without altering the clipboard.

### Line Movement

- **Move entire current line up/down:** `Shift + j/k`
  - Moves the entire current line up or down.

### Highlighting

- **Highlight entire word:** `i + w`
  - Selects the entire word under the cursor.

## Basic Vim Movement Commands

- **Move left:** `h`
- **Move down:** `j`
- **Move up:** `k`
- **Move right:** `l`

- **Move to beginning of the line:** `0`
- **Move to end of the line:** `$`

- **Move forward one word:** `w`
- **Move backward one word:** `b`

- **Move to the top of the screen:** `H`
- **Move to the middle of the screen:** `M`
- **Move to the bottom of the screen:** `L`

- **Move to the start of the file:** `gg`
- **Move to the end of the file:** `G`

- **Delete the word your cursor at the start of:** `d + i`
- **Delete the entire section of words until the next whitespace on either side:** `d + i + W`

- **Move to a specific line:** `:line_number`
  - For example, `:10` moves to line 10.

## Additional Commands

### File Execution

- **Run !chmod +x %< command:** `Space + x`
  - Makes the current file executable.

- **Run JS file with node:** `:!node &`
  - Runs the current file using node.
 
## TMUX
### Tmux sessions
- **How they work in my own words**
  - So a tmux session is created with a name and this is like a box, this is called a window. Inside this box you can have multiple panes where you can open multiple instances of different directories and instances of nvim. IDFK
    
### Commands
- **Tmux prefix key:** `Ctrl + b`
  - This is the keys that should be pressed before any commands which are listed hereafter are executed

- **Create new pane:** `c`
  - Creates a new pane, which show up on the bottom most bar, with its number and name
  
- **Rename a pane:** `,`
  - Rename the current pane you are in
 
- **Switch to next pane:** `n`
  - Switches to the next pane
 
- **Switch to a specific pane by number:** `{number}`
  - Enter a specific number like 1 or 3 and it will move to the pane numbered that

- **Detach from a session:** `d`

- **Switch between sessions:** `s`
  - This will bring up a menu in which you can navigate between sessions
  - Inside this menu you can use just `x` to delete a window
 
