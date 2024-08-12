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
- [TMUX](#tmux)

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
 
# TMUX

## Tmux Sessions

### How They Work (In My Own Words)
A tmux session is like a container, or a "box," where you can manage multiple terminal environments. This container is called a **window**. Inside a window, you can split the view into multiple **panes**, allowing you to work with different directories, instances of `nvim`, or shell commands simultaneously. Each pane acts as a separate terminal, giving you a powerful way to multitask.

## Essential Commands

### Tmux Prefix Key
`Ctrl + b`  
This key combination must be pressed before executing any tmux command.

### Create New Window
`c`  
Creates a new window and shows it in the status bar with its number and name.

### Rename a Window
`,`  
Renames the current window for easy identification.

### Switch to Next Window
`n`  
Switches to the next window in the session.

### Switch to a Specific Window by Number
`{number}`  
Press the number of the window (e.g., `1`, `2`, etc.) to switch directly to that window.

### Detach from a Session
`d`  
Detaches from the current session, allowing it to continue running in the background.

### Switch Between Sessions
`s`  
Opens a menu to navigate between different tmux sessions. Use `x` in this menu to kill a window.

## Advanced Tmux Shortcuts

### Split Window Horizontally
`%`  
Splits the current window into two panes side by side.

### Split Window Vertically
`"`  
Splits the current window into two panes stacked on top of each other.

### Toggle Between Last Two Windows
`l`  
Quickly switch back and forth between the last two windows you used.

### Resize Pane
`Ctrl + b` followed by arrow keys  
Use arrow keys after the prefix to resize the current pane in the desired direction.

### Kill Pane
`x`  
Closes the current pane.

### Kill Window
`&`  
Closes the current window and all its panes.

### Synchronize Panes
`:setw synchronize-panes on`  
When this is enabled, any command you type in one pane will be mirrored in all panes of the window. Disable it with `:setw synchronize-panes off`.

### Copy Mode
`[`  
Enter copy mode to scroll back through the buffer or select text. Use `q` to exit.

### Paste Buffer
`]`  
Paste the last copied text from the tmux buffer into the current pane.

## Customizing Tmux

### Change Prefix Key
If `Ctrl + b` is not comfortable, you can change it. For example, change it to `Ctrl + a` by adding this line to your `.tmux.conf` file:
```bash
set-option -g prefix C-a
unbind-key C-b
bind-key C-a send-prefix


- **Switch between sessions:** `s`
  - This will bring up a menu in which you can navigate between sessions
  - Inside this menu you can use just `x` to delete a window
 
