FROM alpine:latest AS builder

COPY libtorrent-rasterbar libtorrent-rasterbar

RUN cd libtorrent-rasterbar && \
    apk add --no-cache make cmake g++ boost-dev openssl-dev && \
    cmake -DCMAKE_INSTALL_LIBDIR=lib . && \
    make -j`nproc` && \
    make install && \
    #strip /usr/local/lib/libtorrent-rasterbar.so.1.2.2
    #strip /usr/local/lib/libtorrent-rasterbar.so.10
    strip /usr/local/lib/libtorrent-rasterbar.so.2.0

COPY qbittorrent qbittorrent

RUN cd qbittorrent && \
    apk add --no-cache qt5-qttools-dev && \
    ./configure --disable-gui && \
    make -j`nproc` && \
    make install

FROM alpine:latest

#COPY --from=builder /usr/local/lib/libtorrent-rasterbar.so.1.2.2 /usr/lib/libtorrent-rasterbar.so.10
COPY --from=builder /usr/local/lib/libtorrent-rasterbar.so.2.0 /usr/lib/libtorrent-rasterbar.so.2.0

COPY --from=builder /usr/local/bin/qbittorrent-nox /usr/bin/qbittorrent-nox

COPY entrypoint.sh /entrypoint.sh

ENV TZ=Asia/Kuala_Lumpur

RUN apk add --no-cache qt5-qtbase shadow tzdata

ENV TZ=Asia/Kuala_Lumpur

ENV WEBUI_PORT="8080" CHUID=1026 CHGID=100

EXPOSE 6881 6881/udp 8080

VOLUME /config /downloads

ENTRYPOINT ["/entrypoint.sh"]
