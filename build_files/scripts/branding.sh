#!/bin/bash

set -ouex pipefail

sed -i 's/getaurora\.dev/github\.com\/reisaraujo-miguel\/felux/' /usr/lib/os-release
sed -i 's/ublue-os\/bluefin/reisaraujo-miguel\/felux/' /usr/lib/os-release

sed -i 's/Aurora-dx/Felux/' /usr/lib/os-release
sed -i 's/Aurora/Felux/' /usr/lib/os-release
sed -i 's/aurora-dx/felux/' /usr/lib/os-release
sed -i 's/aurora/felux/' /usr/lib/os-release

sed -i 's/Aurora-dx/Felux/' /etc/yafti.yml

sed -i 's/getaurora\.dev/github\.com\/reisaraujo-miguel\/felux/' /usr/share/kde-settings/kde-profile/default/xdg/kcm-about-distrorc
sed -i 's/Aurora-DX/Felux/' /usr/share/kde-settings/kde-profile/default/xdg/kcm-about-distrorc

sed -i 's/aurora-dx/felux/' /usr/share/ublue-os/image-info.json
sed -i 's/ublue-os\/aurora-dx/reisaraujo-miguel\/felux/' /usr/share/ublue-os/image-info.json

sed -i 's@Aurora@Felux@g' /usr/share/applications/system-update.desktop
sed -i 's@Aurora@Felux@g' /usr/share/ublue-os/motd/tips/10-tips.md
sed -i 's@Aurora@Felux@g' /usr/libexec/ublue-flatpak-manager
