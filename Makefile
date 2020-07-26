DROPBOX_ACCESS_TOKEN=`cat dropbox-access-token`

.PHONY: default clean

default: zip

clean:
	rm -r -f -v ./backup
	rm -f -v backup.zip

save: save-fish save-vim save-bash
load: load-fish load-vim load-bash

# Remove backups of loaded dotfiles here:
commit:
	rm -f -v ~/.config/fish/config.fish~
	rm -f -v ~/.config/fish/fish_variables~
	rm -f -v ~/.config/nvim/init.vim~
	rm -f -v -r ~/.config/nvim/autoload~
	rm -f -v ~/.vimrc~
	rm -f -v -r ~/.vim/autoload~

save-fish: init-save-dir
	echo "Saving Fish Config..."
	cp -v ~/.config/fish/config.fish ./backup
	cp -v ~/.config/fish/fish_variables ./backup
load-fish: unzip
	echo "Restoring Fish Config..."
	mkdir -v -p ~/.config/fish
	cp -v -b ./backup/config.fish ~/.config/fish/config.fish
	cp -v -b ./backup/fish_variables ~/.config/fish/fish_variables

save-vim: init-save-dir
	echo "Saving Vim Config..."
	cp -v ~/.config/nvim/init.vim ./backup
	cp -v -r ~/.config/nvim/autoload ./backup
load-vim: unzip
	echo "Restoring Vim Config..."
	mkdir -p ~/.config/nvim
	cp -v -b ./backup/init.vim ~/.config/nvim/init.vim
	mv -v -f ~/.config/nvim/autoload ~/.config/nvim/autoload~
	cp -v -r ./backup/autoload ~/.config/nvim
	mv -v -f ~/.vimrc ~/.vimrc~
	ln -v -s ~/.config/nvim/init.vim ~/.vimrc 
	mkdir -v -p ~/.vim
	mv -v -f ~/.vim/autoload ~/.vim/autoload~
	ln -v -s ~/.config/nvim/autoload ~/.vim/autoload

save-bash: init-save-dir
	echo "Saving Bash Config..."
	cp -v -b ~/.bashrc ./backup
	cp -v -b ~/.profile ./backup
load-bash: unzip
	echo "Restoring Bash Config..."
	cp -v -b ./backup/.bashrc ~/.bashrc
	cp -v -b ./backup/.profile ~/.profile

init-save-dir:
	mkdir -p -v ./backup
zip: save
	zip -9 -r backup.zip ./backup
unzip:
	unzip backup.zip -d .

upload: zip
	curl -X POST https://content.dropboxapi.com/2/files/upload \
		--header "Authorization: Bearer $(DROPBOX_ACCESS_TOKEN)" \
		--header "Dropbox-API-Arg: {\"path\": \"/dotfiles-backup.zip\",\"mode\": \"overwrite\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}" \
		--header "Content-Type: application/octet-stream" \
		--data-binary @backup.zip
download:
	curl -X POST https://content.dropboxapi.com/2/files/download \
		--header "Authorization: Bearer $(DROPBOX_ACCESS_TOKEN)" \
		--header "Dropbox-API-Arg: {\"path\": \"/dotfiles-backup.zip\"}" \
		-o backup.zip
