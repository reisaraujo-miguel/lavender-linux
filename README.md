# Lavender Linux

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/2503a44c1105456483517f793af75ee7)](https://app.codacy.com/gh/reisaraujo-miguel/lavender-linux/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

[![Lavender Image](https://github.com/reisaraujo-miguel/lavender-linux/actions/workflows/build.yml/badge.svg)](https://github.com/reisaraujo-miguel/lavender-linux/actions/workflows/build.yml) [![Lavender ISO](https://github.com/reisaraujo-miguel/lavender-linux/actions/workflows/build-disk.yml/badge.svg)](https://github.com/reisaraujo-miguel/lavender-linux/actions/workflows/build-disk.yml)

Lavender Linux is Bazzite-DX with some extra things

- _MoreWaita Icon Theme:_ For more adwaita style Icons
- _Vanilla Gnome:_ Removes some bazzite customizations
- _Several Dev Runtimes and Dependencies:_ temurin-25-jdk, bun, node, rust, golang etc.
- _Eye Candy for Your Terminal:_ zsh-autosuggestion, zsh-syntax-highlighting, starship (terminal prompt), bat-extras, git-delta, jetbrains-mono, eza (ls replacement)
- _Terminal Dev Tools:_ neovim and lazygit


Rebase to this image from any Fedora SilverBlue based distro with:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/reisaraujo-miguel/lavender-linux:latest
```
