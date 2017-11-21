#!/usr/bin/env bash
gpg --import /secrets/public.gpg
gpg --import /secrets/private.gpg

touch /travis/${PLATFORM}/build_results
