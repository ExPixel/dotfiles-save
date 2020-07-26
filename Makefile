DROPBOX_ACCESS_TOKEN=`cat dropbox-access-token`
.PHONY: default

default: save

save: save-fish save-vim save-bash
	make zip
	rm -r ./stored
load: load-fish load-vim load-bash

save-fish: init-save-dir
	echo "Saving Fish Config..."
	cp ~/.config/fish/config.fish ./stored
	cp ~/.config/fish/fish_variables ./stored
load-fish: unzip
	echo "Restoring Fish Config..."
	mkdir -p ~/.config/fish
	cp ./stored/config.fish ~/.config/fish/config.fish
	cp ./stored/fish_variables ~/.config/fish/fish_variables

save-vim: init-save-dir
	echo "Saving Vim Config..."
	cp ~/.config/nvim/init.vim ./stored
	cp -r ~/.config/nvim/autoload ./stored
load-vim: unzip
	echo "Restoring Vim Config..."
	mkdir -p ~/.config/nvim
	cp ./stored/init.vim ~/.config/nvim/init.vim
	cp -r ./stored/autoload ~/.config/nvim/autoload
	ln -s ~/.config/nvim/init.vim ~/.vimrc 
	mkdir -p ~/.vim
	ln -s ~/.config/nvim/autoload ~/.vim/autoload

save-bash: init-save-dir
	echo "Saving Bash Config..."
	cp ~/.bashrc ./stored
	cp ~/.profile ./stored
load-bash: unzip
	echo "Restoring Bash Config..."
	cp ./stored/.bashrc ~/.bashrc
	cp ./stored/.profile ~/.profile

init-save-dir:
	mkdir -p ./stored
zip:
	zip -9 -r stored.zip ./stored
unzip:
	unzip stored.zip -d .
