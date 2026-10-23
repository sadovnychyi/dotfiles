HOMEBREW_PREFIX ?= /opt/homebrew

.PHONY: build sync

build:
	@ln -sfn "$(CURDIR)/.gitconfig" "$(HOME)/.gitconfig"
	@ln -sfn "$(CURDIR)/.gitignore_global" "$(HOME)/.gitignore"
	@ln -sfn "$(CURDIR)/.pyrc" "$(HOME)/.pyrc"
	@ln -sfn "$(CURDIR)/.zprofile" "$(HOME)/.zprofile"
	@ln -sfn "$(CURDIR)/.zshrc" "$(HOME)/.zshrc"
	@ln -sfn "$(CURDIR)/.hushlogin" "$(HOME)/.hushlogin"
	@ln -sfn "$(CURDIR)/.mackup.cfg" "$(HOME)/.mackup.cfg"
	@ln -sfn "$(CURDIR)/nginx.conf" "$(HOMEBREW_PREFIX)/etc/nginx/nginx.conf"
	@echo "Created symbolic links. Run 'exec zsh -l' to reload your shell."

sync:
	@cp ~/Library/Application\ Support/Code/User/settings.json vscode/settings.json
	@cp ~/Library/Application\ Support/Code/User/keybindings.json vscode/keybindings.json
	@code --list-extensions > vscode/extensions.txt
