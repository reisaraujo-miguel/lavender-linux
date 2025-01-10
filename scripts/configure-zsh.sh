#!/bin/bash

set -ouex pipefail

for FILE in /etc/zsh/*; do
  if [ -f "$FILE" ]; then
    BASENAME=$(basename "$FILE")
    cp "$FILE" /etc/skel/.config/zsh/."$BASENAME"
  fi
done
