#!/bin/bash

set -ouex pipefail

git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde

cd catppuccin-kde

<<<<<<< HEAD
eval "$BUILD_FILES_DIR/scripts/install-catppuccin-theme.sh" 2 4 1
=======
cp $BUILD_FILES_DIR/scripts/install-catppuccin-theme.sh ./install.sh

./install.sh 2 4 1
>>>>>>> 8b7d316 (refactor)

cd ..

rm -r catppuccin-kde
<<<<<<< HEAD
=======

>>>>>>> 8b7d316 (refactor)
