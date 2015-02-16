build:
	@ln -fs `pwd`/.bash* `pwd`/.gitconfig `pwd`/.inputrc ~
	@ln -fs `pwd`/.atom/* ~/.atom
	@tput setaf 6
	@echo "Successfully created symbolic links in home directory."
	@tput sgr0
	@exec /usr/local/bin/bash -l
