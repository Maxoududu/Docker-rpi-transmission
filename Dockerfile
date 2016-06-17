FROM hypriot/rpi-alpine-scratch
# FROM alpine

RUN apk update
# apk upgrade && \
# apk add bash

# Install transmission
RUN apk add transmission-daemon

# Remove cache
RUN rm -rf /var/cache/apk/*

# Create user transmission and add it to the "users" group
RUN id transmission || adduser -S -s /bin/false -H -D transmission
RUN addgroup transmission users

RUN mkdir -p /downloads /incomplete /config /watch && \
    chmod 775 /downloads /incomplete /config /watch && \
    chgrp -R users /downloads /watch
RUN chown -R transmission:users /incomplete /config

# Continue as user 'transmission'
USER transmission

# Expose volumes:
# - downloads for completed downloads to be sorted
# - incomplete for ongoing downloads
# - config for configuration files
# - watch to trigger downloads when a torrent is added
VOLUME /downloads /incomplete /config /watch

EXPOSE 9091
EXPOSE 51413
EXPOSE 51413/udp

CMD ["/usr/bin/transmission-daemon", "-f", "-g", "/config"]
