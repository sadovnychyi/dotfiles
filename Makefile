build:
	@ln -fs `pwd`/.bash* `pwd`/.gitconfig `pwd`/.inputrc `pwd`/.pyrc ~
	@ln -fs `pwd`/.atom/* ~/.atom
	@ln -fs /Users/dmitry/google-cloud-sdk/platform/google_appengine/ /usr/local/
	@tput setaf 6
	@echo "Successfully created symbolic links in home directory."
	@tput sgr0
	@exec /usr/local/bin/bash -l
