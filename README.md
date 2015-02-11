# dotfiles

# Requirements

```bash
brew install git hub bash bash-completion ngrep
sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
chsh -s /usr/local/bin/bash
```

# Bash Keyboard Shortcuts

`bind -P` to see all current keyboard shortcuts used.
Be sure to check `Use option as meta key` in terminal settings.

Non-default shortcuts are highlighted in bold.

Keystroke                         | Description
---------------------------------:|---------------------------------------------
Ctrl + a                          | Go to the beginning of the line (Home) TODO: cmd + arrow left
Ctrl + e                          | Go to the End of the line (End) TODO: cmd + arrow right
Ctrl + p, Arrow Up                | Previous command
Ctrl + n, Arrow Down              | Next command
Alt + b, **Option + Arrow Left**  | Back (left) one word
Alt + f, **Option + Arrow Right** | Forward (right) one word
Ctrl + xx                         | Toggle between the start of line and current cursor position
Ctrl + L                          | Clear the Screen, similar to the clear command
Alt + Del                         | Delete the Word before the cursor
Alt + d                           | Delete the Word after the cursor
Ctrl + w                          | Cut the Word before the cursor to the clipboard
Ctrl + k                          | Cut the Line after the cursor to the clipboard
Ctrl + u                          | Cut/delete the Line before the cursor to the clipboard
Alt + t                           | Swap current word with previous
Ctrl + t                          | Swap the last two characters before the cursor (typo)
Ctrl + y                          | Paste the last thing to be cut (yank)
Alt + u                           | UPPER capitalize every character from the cursor to the end of the current word
Alt + l                           | Lower the case of every character from the cursor to the end of the current word
Alt + c                           | Capitalize the character under the cursor and move to the end of the word
Alt + r                           | Cancel the changes and put back the line as it was in the history (revert)
ctrl + _                          | Undo
TAB                               | Tab completion for file/directory names
Ctrl + r                          | Recall the last command including the specified character(s) searches the command history as you type
Ctrl + p, Arrow Up                | Previous command in history (i.e. walk back through the command history)
Ctrl + n, Arrow Down              | Next command in history (i.e. walk forward through the command history)
Ctrl + C                          | Interrupt/Kill whatever you are running (SIGINT)
Ctrl + l                          | Clear the screen
Ctrl + s                          | Stop output to the screen (for long running verbose commands)
Ctrl + q                          | Allow output to the screen (if previously stopped using command above)
Ctrl + D                          | Send an EOF marker, unless disabled by an option, this will close the current shell (EXIT)
Ctrl + Z                          | Send the signal SIGTSTP to the current task, which suspends it. To return to it later enter `fg job_name` (foreground) or use `jobs` to list all available jobs
!!                                | Repeat last command
!abc                              | Run last command starting with abc
!abc:p                            | Print last command starting with abc
!$                                | Last argument of previous command
ALT + .                           | Last argument of previous command
!*                                | All arguments of previous command
^abc­^­def                          | Run previous command, replacing abc with def

# Credits

* http://www.ukuug.org/events/linux2003/papers/bash_tips/
* http://ss64.com/bash/syntax-keyboard.html
* http://stackoverflow.com/questions/68372/what-is-your-single-most-favorite-command-line-trick-using-bash
* http://www.unixlore.net/articles/save-time-command-line-bash-shell.html
* http://www.ukuug.org/events/linux2003/papers/bash_tips/
* https://github.com/mathiasbynens/dotfiles
* http://wiki.bash-hackers.org/internals/shell_options
