if [ ! -d "/home/cmls/.unsplash" ]; then
	mkdir -p /home/cmls/.unsplash
	touch /home/cmls/.unsplash/.theme
fi

readonly PIC_PATH="/home/cmls/.unsplash"
readonly PIC_FILE=''"$PIC_PATH"'/today.jpeg'
THEME="$(cat $PIC_PATH/.theme)"

setupDirectory() {
	mkdir -p $PIC_PATH
}

downloadToday() {
	local RES=$(xdpyinfo | awk '/dimensions/{print $2}')
	local URL='https://source.unsplash.com/'"$RES"'/?'"$THEME"''
	# echo 'saving from ["'"$URL"'"] to ['"$PIC_FILE"'] '
	wget -O ''"$PIC_FILE"'' ''"$URL"''
}

updateBackground() {
	local PIC_URI='file://'"$PIC_FILE"''
	gsettings set org.gnome.desktop.background picture-uri "$PIC_URI" 
}

favfolder=default
if [ ! -z $2 ]; then
	favfolder=$2
fi

if [ -z $1 ] || [ $1 == "new-bg" ]; then
	setupDirectory
	downloadToday
	updateBackground

elif [ $1 == "new-theme" ]; then
	rm "$PIC_PATH/.theme"
	echo "$2" >> "$PIC_PATH/.theme"

elif [ $1 == "save-fav" ]; then
	if [ ! -d "$PIC_PATH/$favfolder" ]; then
		mkdir -p "$PIC_PATH/$favfolder"
	fi

	cp "$PIC_PATH/today.jpeg" "$PIC_PATH/$favfolder/fav-$RANDOM.jpeg"

elif [ $1 == "load-fav" ]; then
	rfav=$(ls "$PIC_PATH/$favfolder/" | sort -R | tail -1)
	cp "$PIC_PATH/$favfolder/$rfav" "$PIC_PATH/today.jpeg"
	updateBackground

elif [ $1 == "import-fav" ]; then
	favfolder=default
	if [ ! -z $3 ]; then
		favfolder=$3
	fi
	cp "$2" "$PIC_PATH/$favfolder/fav-$RANDOM.jpeg"

elif [ $1 == "remove-favs" ]; then
	favfolder=default
	if [ ! -z $2 ]; then
		favfolder=$2
	fi
	rm -rf "$PIC_PATH/$favfolder"
	
else
	if [ ! $1 == "help" ]; then
		echo "Ah! I don't know what you just asked me to do!!"
		echo "Try something along the lines of"
	else
		echo "Here are some possible commands you can use."
	fi
	
	echo ""
	echo "- SAMpaper                              # shortcut for SAMpaper new-bg"
	echo "- SAMpaper new-bg                       # generates a new background"
	echo "- SAMpaper new-theme rocks              # tells me to prefer images of rocks"
	echo "- SAMpaper save-fav                     # saves the current background as a favourite"
	echo "- SAMpaper save-fav cool-rocks          # saves the current background as a favourite, under the folder 'cool-rocks'"
	echo "- SAMpaper load-fav                     # loads a random favourite"
	echo "- SAMpaper load-fav cool-rocks          # loads a random favourite from the 'cool-rocks' folder"
	echo "- SAMpaper import-fav ~/abc.png letters # imports a file named abc.png, into the 'letters' folder"
	echo "- SAMpaper remove-favs cool-rocks       # removes your cool-rocks folder. oh no!"
	echo "- SAMpaper help                         # displays a help message"
	echo ""
fi

