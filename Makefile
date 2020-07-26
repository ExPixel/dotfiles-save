DROPBOX_ACCESS_TOKEN=`cat dropbox-access-token`

.PHONY: default clean

default: zip

clean:
	rm -r -f -v ./backup
	rm -f -v backup.zip

save: save-fish save-vim save-bash
load: load-fish load-vim load-bash

save-fish: init-save-dir
	echo "Saving Fish Config..."
	cp -v ~/.config/fish/config.fish ./backup
	cp -v ~/.config/fish/fish_variables ./backup
load-fish: unzip
	echo "Restoring Fish Config..."
	mkdir -v -p ~/.config/fish
	cp -v ./backup/config.fish ~/.config/fish/config.fish
	cp -v ./backup/fish_variables ~/.config/fish/fish_variables

save-vim: init-save-dir
	echo "Saving Vim Config..."
	cp -v ~/.config/nvim/init.vim ./backup
	cp -v -r ~/.config/nvim/autoload ./backup
load-vim: unzip
	echo "Restoring Vim Config..."
	mkdir -p ~/.config/nvim
	cp -v ./backup/init.vim ~/.config/nvim/init.vim
	cp -v -r ./backup/autoload ~/.config/nvim/autoload
	ln -v -s ~/.config/nvim/init.vim ~/.vimrc 
	mkdir -v -p ~/.vim
	ln -v -s ~/.config/nvim/autoload ~/.vim/autoload

save-bash: init-save-dir
	echo "Saving Bash Config..."
	cp -v ~/.bashrc ./backup
	cp -v ~/.profile ./backup
load-bash: unzip
	echo "Restoring Bash Config..."
	cp -v ./backup/.bashrc ~/.bashrc
	cp -v ./backup/.profile ~/.profile

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
