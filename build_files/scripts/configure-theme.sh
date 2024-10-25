#!/bin/bash

set -ouex pipefail

git clone --depth=1 https://github.com/catppuccin/kde-catppuccin-kde

cd catppuccin-kde

eval $BUILD_FILES_DIR/scripts/install-catppuccin-theme.sh 2 4 1

cd ..

rm -r catppuccin-kde

cp $BUILD_FILES_DIR/configs/felux-theme-defaults/defaults /usr/share/plasma/look-and-feel/Catppuccin-Macchiato-Mauve/contents/
