ARG TAG=2-alpine
ARG BUILDER_TAG=2-builder-alpine

FROM --platform=${TARGETPLATFORM} caddy:${BUILDER_TAG} AS builder
RUN xcaddy build --with github.com/caddy-dns/cloudflare

LABEL maintainer="fordes123 <github.com/fordes123>"
FROM --platform=${TARGETPLATFORM} caddy:${TAG}
COPY --from=builder /usr/bin/caddy /usr/bin/caddy