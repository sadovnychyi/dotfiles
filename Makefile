build:
	@ln -fs `pwd`/.gitconfig ~
	@ln -fs `pwd`/.pyrc ~
	@ln -fs `pwd`/.zshrc ~
	@ln -fs `pwd`/.zshenv ~
	@ln -fs `pwd`/.hushlogin ~
	@ln -fh vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	@ln -fh vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	@tput setaf 6
	@echo "Successfully created symbolic links in home directory."
	@tput sgr0
	@exec /opt/homebrew/bin/zsh -l
	@ln -fh nginx.conf /opt/homebrew/etc/nginx/nginx.conf
