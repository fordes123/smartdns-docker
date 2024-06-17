FROM debian:bullseye-slim AS smartdns-builder
LABEL previous-stage=smartdns-builder

ARG TAG=Release46
ARG REPOSITORY=pymumu/smartdns
ARG TARGETPLATFORM=linux/amd64

WORKDIR /build
RUN apt update && \
    apt install -y git make gcc libssl-dev && \
    case "${TARGETPLATFORM}" in \
        "linux/amd64") TARGET="x86-64" ;; \
        "linux/arm64") TARGET="arm64" ;; \
        *) echo "Unsupported Platform: ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    git clone https://github.com/${REPOSITORY} smartdns &&  \
    cd smartdns && \
    git fetch --all --tags && \
    git checkout tags/${TAG} && \
    sh package/build-pkg.sh --platform linux --arch $TARGET --static && \
    strip -s src/smartdns

FROM --platform=${TARGETPLATFORM} alpine:latest
LABEL maintainer="fordes123 <github.com/fordes123>"

ENV UPDATE_INTERVAL "0 0 */7 * *"

USER root
WORKDIR /etc/smartdns
VOLUME ["/etc/smartdns/"]

ADD https://gcore.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/china-list.txt /etc/smartdns/geosite_cn.txt
COPY --from=smartdns-builder /build/smartdns/src/smartdns /usr/sbin
COPY smartdns.conf /etc/smartdns/smartdns.conf

RUN apk add --no-cache curl && \
    echo "#!/bin/sh" > /update.sh && \
    echo "curl -o /etc/smartdns/geosite_cn.txt -L https://gcore.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/china-list.txt" >> /update.sh && \
    echo "kill -HUP 1" >> /update.sh && \
    chmod a+x /*.sh

EXPOSE 53/udp 53/tcp
CMD echo "$UPDATE_INTERVAL /update.sh" > /etc/crontabs/root && /usr/sbin/crond -b -l 8 && /usr/sbin/smartdns -f -x