#!/bin/sh

cp /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
echo "Set Time-Zone to Kuala Lumpur"
echo "Asia/Kuala_Lumpur" > /etc/timezone

if ! id qbittorrent; then
    echo "[WARNING] User not found. Maybe first bootstrap?"
    echo "[INFO] Try to create user qbittorrent."
    groupadd -g $CHGID -o qbittorrent
    useradd -d /config -u $CHUID -g $CHGID -o qbittorrent
    if [ -d /config ]; then
        echo "[INFO] Try to fix config folder permissions."
        chown -R $CHUID:$CHGID /config
    fi
    echo "[INFO] User qbittorrent($CHUID:$CHGID) created."
fi

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
    chown $CHUID:$CHGID /config/qBittorrent/qBittorrent.conf
fi

su qbittorrent << EOF
HOME="/config" XDG_CONFIG_HOME="/config" XDG_DATA_HOME="/config" qbittorrent-nox --webui-port=$WEBUI_PORT
EOF
