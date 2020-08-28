build:
	@ln -fs `pwd`/.bash* `pwd`/.gitconfig ~
	@ln -fs `pwd`/.*rc ~
	@ln -fs `pwd`/.zshrc ~
	@ln -fs `pwd`/.zshenv ~
	@ln -fs `pwd`/.hushlogin ~
	@mkdir -p ~/.atom && ln -fs `pwd`/.atom/* ~/.atom
	@ln -h vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	@ln -h vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	@tput setaf 6
	@echo "Successfully created symbolic links in home directory."
	@tput sgr0
	@exec /usr/local/bin/bash -l
	@ln -fh nginx.conf /usr/local/etc/nginx/nginx.conf
