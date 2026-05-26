# Dotfiles

This repository stores shell configuration and command bookmarks.

Managed files:
- bashrc -> ~/.bashrc
- zshrc -> ~/.zshrc
- command_bookmarks -> ~/.command_bookmarks
- config/fish/config.fish -> ~/.config/fish/config.fish

To install on a new system:

```bash
git clone <your-repo-url> ~/dotfiles
ln -s ~/dotfiles/bashrc ~/.bashrc
ln -s ~/dotfiles/zshrc ~/.zshrc
mkdir -p ~/.config/fish
ln -s ~/dotfiles/config/fish/config.fish ~/.config/fish/config.fish
ln -s ~/dotfiles/command_bookmarks ~/.command_bookmarks
```
