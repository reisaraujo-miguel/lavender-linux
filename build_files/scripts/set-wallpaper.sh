#!/bin/bash

set -ouex pipefail

cp $BUILD_FILES_DIR/wallpaper/cat-wallpaper.jpg /usr/share/wallpapers/cat-wallpaper.jpg

ln -sf /usr/share/wallpapers/cat-wallpaper.jpg /usr/share/backgrounds/default.png
ln -sf /usr/share/wallpapers/cat-wallpaper.jpg /usr/share/backgrounds/default-dark.png
