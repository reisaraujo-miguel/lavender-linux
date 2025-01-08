#!/bin/bash

set -ouex pipefail

sed -i '/setopt noglobalrcs/d' /etc/zsh/zshenv
