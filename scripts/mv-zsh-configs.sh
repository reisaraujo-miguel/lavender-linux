#!/usr/bin/env bash

for FILE in /etc/zsh/*; do
  if [ -f "$FILE" ]; then
    BASENAME=$(basename "$FILE")
    mv "$FILE" /etc/skel/.config/zsh/."$BASENAME"
  fi
done
