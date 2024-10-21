#!/bin/bash

set -ouex pipefail

rm /etc/skel/.zshrc
rm /etc/skel/.zprofile
<<<<<<< HEAD
=======

cp $BUILD_FILES_DIR/configs/zshenv /etc/skel/.zshenv

mkdir -p /etc/skel/.config/zsh/theme

cp $BUILD_FILES_DIR/configs/zsh/themes/catppuccin.zsh-theme /etc/skel/.config/zsh/theme/catppuccin.zsh-theme

cp $BUILD_FILES_DIR/configs/zsh/zlogin /etc/skel/.config/zsh/.zlogin

cp $BUILD_FILES_DIR/configs/zsh/zlogout /etc/skel/.config/zsh/.zlogout

cp $BUILD_FILES_DIR/configs/zsh/zprofile /etc/skel/.config/zsh/.zprofile

cp $BUILD_FILES_DIR/configs/zsh/zshrc /etc/skel/.config/zsh/.zshrc
>>>>>>> 8b7d316 (refactor)
