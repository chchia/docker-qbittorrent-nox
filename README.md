# qbittorrent-nox
forked originally from caoli5288
and modded to suite the latest qbittorrent 4.4 master branch and libtorrent RC_2_0 branch.

```
Very minimal qbittorrent-nox image build from latest git master branch, forked from caoli5288

check your UID and GID in synology and keyin correctly.

## Usage

```bash
$ docker create --name=qbittorrent-nox \
  -e WEBUI_PORT=8080 \
  -e CHUID=1000 \
  -e CHGID=1000 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -p 8080:8080 \
  -v /path/to/appdata/config:/config \
  -v /path/to/downloads:/downloads \
  --restart unless-stopped \
  caoli5288/qbittorrent-nox
```
```
