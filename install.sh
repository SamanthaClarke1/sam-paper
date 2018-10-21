if [ ! -f "/home/$USER/unsplash/unsplash.sh" ]; then
	echo "Installer reached a fatal error, and could not continue."
	echo "Please ensure that the files are placed in ~/unsplash/"
else
	mkdir -p "/home/$USER/.unsplash/default"
	touch "/home/$USER/.unsplash/.theme"
	if [ ! $(grep -q "alias SAMpaper=" ~/.bashrc) ]; then echo "alias SAMpaper='~/unsplash/unsplash.sh'" | tee -a ~/.bashrc && source ~/.bashrc; fi
fi
