#!/bin/bash
set -e

#
# Display settings on standard out.
#

USER="plex"

echo "Plex settings"
echo "============="
echo
echo "  User:       ${USER}"
echo "  UID:        ${PLEX_UID:=666}"
echo "  GID:        ${PLEX_GID:=666}"
echo

#
# Change UID / GID of Plex user.
#

printf "Updating UID / GID... "
[[ $(id -u ${USER}) == ${PLEX_UID} ]] || usermod  -o -u ${PLEX_UID} ${USER}
[[ $(id -g ${USER}) == ${PLEX_GID} ]] || groupmod -o -g ${PLEX_GID} ${USER}
echo "[DONE]"

#
# Set directory permissions.
#

printf "Set permissions... "
chown -R ${USER}: /config /transcode
echo "[DONE]"

#
# Finally, start Plex.
#

echo "Starting Plex..."
exec su -pc "/usr/sbin/start_pms" ${USER}
