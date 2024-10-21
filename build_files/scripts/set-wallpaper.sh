#!/bin/bash

set -ouex pipefail

<<<<<<< HEAD
ln -sf /usr/share/wallpapers/Felux/contents/images/6000x4000.jpg /usr/share/backgrounds/default.png
ln -sf /usr/share/wallpapers/Felux/contents/images/6000x4000.jpg /usr/share/backgrounds/default-dark.png
=======
cp $BUILD_FILES_DIR/wallpaper/cat-wallpaper.jpg /usr/share/wallpapers/cat-wallpaper.jpg

ln -sf /usr/share/wallpapers/cat-wallpaper.jpg /usr/share/backgrounds/default.png
ln -sf /usr/share/wallpapers/cat-wallpaper.jpg /usr/share/backgrounds/default-dark.png
>>>>>>> 8b7d316 (refactor)
