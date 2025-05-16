FROM debian:bookworm

RUN apt-get update \
  && apt-get install \
    -y --no-install-recommends \
    ca-certificates \
    wireguard \
    iproute2 \
    python3 \
    ffmpeg \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY ./entrypoint.sh ./
COPY ./wg_client.sh ./
ADD https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp /app/yt-dlp

RUN chmod 500 \
  /app/yt-dlp \
  /app/entrypoint.sh \
  /app/wg_client.sh

# For debug
# RUN apt-get update \
#   && apt-get install \
#     -y --no-install-recommends \
#     vim \
#     curl \
#     iputils-ping \
#     procps \
#     bind9-dnsutils \
#     traceroute

WORKDIR /downloads

ENTRYPOINT ["/app/entrypoint.sh"]
