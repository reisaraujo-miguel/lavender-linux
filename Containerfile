ARG SOURCE_IMAGE="aurora"
ARG SOURCE_SUFFIX="-dx"
ARG SOURCE_TAG="latest"

FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}

# copy build files
COPY build.sh /tmp/build.sh
COPY build_files /tmp/build_files

RUN mkdir -p /var/lib/alternatives \
	&& chmod +x /tmp/build.sh \
	&& chmod +x /tmp/build_files/scripts/* \
	&& /tmp/build.sh \
	&& ostree container commit

## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
