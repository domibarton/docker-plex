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
# Setup trap for SIGTERM
#

function stop
{
    source /etc/default/plexmediaserver
    PIDFILE="${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}/Plex Media Server/plexmediaserver.pid"

    printf "Stopping Plex Media Server by PID..."
    kill $(cat "${PIDFILE}")
    echo "[DONE]"

    printf "Removing PID file..."
    rm -f "${PIDFILE}"
    echo "[DONE]"

    echo "Exiting..."
    exit 0
}

trap stop 0

#
# Finally, start Plex.
#

echo "Starting Plex..."
su -pc "/usr/sbin/start_pms" ${USER}