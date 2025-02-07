dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras}
dnf5 -y config-manager setopt "*terra*".priority=3 "*terra*".exclude='nerd-fonts topgrade'

# Install Valve's patched Mesa, Pipewire, Bluez, and Xwayland
bazzite_packages="pipewire bluez xorg-x11-server-Xwayland"

for package in $bazzite_packages; do
	dnf5 -y swap --repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib "$package" "$package"
done

dnf5 -y swap --repo=terra-extras mesa-filesystem mesa-filesystem
