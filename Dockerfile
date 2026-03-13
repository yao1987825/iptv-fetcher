FROM curlimages/curl:latest

WORKDIR /data

ENV SOURCE_URL=https://gh-proxy.com/https://raw.githubusercontent.com/yaojiwei520/IPTV/refs/heads/main/iptv.m3u
ENV FETCH_INTERVAL=3600
ENV OUTPUT_FILE=/data/iptv.m3u

CMD sh -c 'while true; do curl -fsSL "$SOURCE_URL" -o /data/iptv.m3u.tmp && mv /data/iptv.m3u.tmp /data/iptv.m3u && echo "$(date -Iseconds) updated"; sleep $FETCH_INTERVAL; done'
