build:
	@ln -fs `pwd`/.gitconfig ~
	@ln -fs `pwd`/.pyrc ~
	@ln -fs `pwd`/.zshrc ~
	@ln -fs `pwd`/.hushlogin ~
	@ln -fs `pwd`/.mackup.cfg ~
	@tput setaf 6
	@echo "Successfully created symbolic links in home directory."
	@tput sgr0
	@exec /opt/homebrew/bin/zsh -l
	@ln -fh nginx.conf /opt/homebrew/etc/nginx/nginx.conf

sync:
	@cp ~/Library/Application\ Support/Code/User/settings.json vscode/settings.json
	@cp ~/Library/Application\ Support/Code/User/keybindings.json vscode/keybindings.json
	@code --list-extensions > vscode/extensions.txt
