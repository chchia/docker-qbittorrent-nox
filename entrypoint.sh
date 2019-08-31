#!/bin/sh

adduser --home /config --uid $CHUID --gid $CHGID --disabled-password qbittorrent

if [ ! -f /config/qBittorrent/qBittorrent.conf ]; then
    mkdir -p /config/qBittorrent/
    cat << EOF > /config/qBittorrent/qBittorrent.conf
[AutoRun]
enabled=false
program=

[LegalNotice]
Accepted=true

[Preferences]
Connection\UPnP=false
Connection\PortRangeMin=6881
Downloads\SavePath=/downloads/
Downloads\ScanDirsV2=@Variant(\0\0\0\x1c\0\0\0\0)
Downloads\TempPath=/downloads/incomplete/
WebUI\Address=*
WebUI\ServerDomains=*
EOF
    chown qbittorrent:qbittorrent /config/qBittorrent/qBittorrent.conf
fi

su qbittorrent << EOF
HOME="/config" XDG_CONFIG_HOME="/config" XDG_DATA_HOME="/config" qbittorrent-nox --webui-port=$WEBUI_PORT
EOF
