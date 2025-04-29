#!/bin/bash

set -ouex pipefail

systemctl enable sddm.service --force
