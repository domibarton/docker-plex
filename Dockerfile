FROM ubuntu:14.04
MAINTAINER Dominique Barton

#
# Create user and group for Plex.
#

RUN groupadd -r -g 666 plex \
    && useradd -r -u 666 -g 666 plex

#
# Add Plex init script.
#

ADD plex.sh /plex.sh
RUN chmod 755 /plex.sh

#
# Install Plex and all required dependencies.
#

RUN export VERSION=0.9.16.1.1794-af21b7e \
    && apt-get -q update \
    && apt-get install -qy curl gdebi-core \
    && curl -o /tmp/plexmediaserver_amd64.deb https://downloads.plex.tv/plex-media-server/${VERSION}/plexmediaserver_${VERSION}_amd64.deb \
    && gdebi -n /tmp/plexmediaserver_amd64.deb \
    && apt-get -y remove curl gdebi-core \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

#
# Add plex defaults.
#

ADD default /etc/default/plexmediaserver
RUN chmod 644 /etc/default/plexmediaserver

#
# Define container settings.
#

VOLUME ["/config", "/transcode", "/media"]

EXPOSE 8081

#
# Start Plex Media Server.
#

WORKDIR /config
CMD ["/plex.sh"]
