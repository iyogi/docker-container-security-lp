FROM alpine:3.12.0

ARG CREATED_DATE
ARG VCS_REF
ARG VERSION
LABEL maintainer="PS <psellars@gmail.com>" \
      org.opencontainers.image.created="$CREATED_DATE" \
      org.opencontainers.image.revision="$VCS_REF" \
      org.opencontainers.image.version="$VERSION" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.url="https://github.com/iyogi/docker-container-security-lp" \
      org.opencontainers.image.title="Making registry ontainers secure, robust and verifiable"

RUN apk add --no-cache \
    curl=7.69.1-r0 \
    git=2.26.2-r0 \
    openssh-client=8.3_p1-r0 \
    rsync=3.1.3-r3

ENV VERSION 0.64.0
ENV HUGO_FILE_TARGZ hugo.tar.gz

WORKDIR /tmp

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN curl -o ${HUGO_FILE_TARGZ} -fSL https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_linux-64bit.tar.gz; \
    echo "99c4752bd46c72154ec45336befdf30c28e6a570c3ae7cc237375cf116cba1f8 *${HUGO_FILE_TARGZ}" | sha256sum -c -;  tar -xvf ${HUGO_FILE_TARGZ} \
    && mv hugo /usr/local/bin/hugo \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo \
    && rm -rf /tmp/*

USER hugo

WORKDIR /src

EXPOSE 1313

ENTRYPOINT ["hugo", "server", "-w", "--bind=0.0.0.0"]

HEALTHCHECK CMD hugo --debug