#!/bin/bash

sed -i 's|/usr/bin/ptyxis|/usr/bin/ghostty|g' /usr/bin/xdg-terminal-exec

sed -i 's|ghostty -- "$@"|ghostty -e "$@"|g' /usr/bin/xdg-terminal-exec

sed -i 's|ptyxis|ghostty|g' /usr/share/glib-2.0/schemas/zz0-00-bazzite-desktop-silverblue-global.gschema.override
