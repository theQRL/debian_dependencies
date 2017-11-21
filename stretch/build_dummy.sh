#!/usr/bin/env bash
gpg --import /secrets/public.gpg
gpg --import /secrets/private.gpg

mkdir -p /travis/${PLATFORM}
touch /travis/${PLATFORM}/build_results
chown -R $USER_INFO /travis
