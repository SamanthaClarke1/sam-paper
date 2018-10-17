if [ ! -f "/home/$USER/unsplash/unsplash.sh" ]; then
	echo "Installer reached a fatal error, and could not continue."
	echo "Please ensure that the files are placed in ~/unsplash/"
else
	mkdir -p "/home/$USER/.unsplash/default"
	touch "/home/$USER/.unsplash/.theme"
	echo "alias SAMpaper='/unsplash/unsplash.sh'" >> ~/.bash_aliases && source ~/.bash_aliases
fi