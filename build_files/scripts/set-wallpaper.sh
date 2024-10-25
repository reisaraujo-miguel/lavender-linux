#!/bin/bash

set -ouex pipefail

cp $BUILD_FILES_DIR/wallpaper/Felux /usr/share/wallpapers/

ln -sf /usr/share/wallpapers/Felux/contents/images/6000x4000.jpg /usr/share/backgrounds/default.png
ln -sf /usr/share/wallpapers/Felux/contents/images/6000x4000.jpg /usr/share/backgrounds/default-dark.png
