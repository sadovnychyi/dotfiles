build:
	@ln -fs `pwd`/.bash* `pwd`/.gitconfig ~
	@ln -fs `pwd`/.*rc ~
	@mkdir -p ~/.atom && ln -fs `pwd`/.atom/* ~/.atom
	@ln -fs /Users/sadovnychyi/google-cloud-sdk/platform/google_appengine/ /usr/local/ /usr/local/
	@tput setaf 6
	@echo "Successfully created symbolic links in home directory."
	@tput sgr0
	@exec /usr/local/bin/bash -l
