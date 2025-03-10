# Install Valve's patched Mesa, Pipewire, Bluez, and Xwayland
bazzite_packages="pipewire bluez xorg-x11-server-Xwayland"

for package in $bazzite_packages; do
	dnf5 -y swap --repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib "$package" "$package"
done

dnf5 -y swap --repo=terra-extras mesa-filesystem mesa-filesystem
