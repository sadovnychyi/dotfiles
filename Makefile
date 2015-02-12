build:
	@ln -fs `pwd`/.bash* `pwd`/.gitconfig `pwd`/.inputrc ~
	@tput setaf 6
	@echo "Successfully created symbolic links in home directory."
	@tput sgr0
	@exec /usr/local/bin/bash -l
