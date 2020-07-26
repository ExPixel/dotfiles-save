Simple utility for zipping up and uploading my dotfiles using make.
If you want to make use of this yourself and enable dropbox upload/download
follow these steps:

1. Login to the Dropbox App Console here: `https://www.dropbox.com/developers/`.
2. Create an application with whatever name you want (I call mine `Dotfiles`).
3. Have the application use its own folder because the backup file will be placed at the root.
4. In the App Console get an access token for the application and place it into a file called
   `dropbox-access-token` here.

Usage
===
You will have to customize `make save` and `make load` and the accompanying `make save-*` and `make load-*` tasks
in order to save and load your own dotfiles to and from the `backup` directory. After that you can use `make upload`
to zip up everything in the `backup` directory and place it into dropbox and `make download` followed by `make load`
to download the dotfiles from dropbox and load them back to their locations. Make sure that all `load` operations
create backups of the files they are overwriting and pay attention to possible cycles (like moving a directory before
creating a symlink inside of it that might create a possible cycle).
