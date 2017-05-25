build:
	@ln -fs `pwd`/.bash* `pwd`/.gitconfig ~
	@ln -fs `pwd`/.*rc ~
	@ln -fs `pwd`/.hushlogin ~
	@mkdir -p ~/.atom && ln -fs `pwd`/.atom/* ~/.atom
	@tput setaf 6
	@echo "Successfully created symbolic links in home directory."
	@tput sgr0
	@exec /usr/local/bin/bash -l
