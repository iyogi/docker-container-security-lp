FROM alpine:3.12.0

LABEL maintainer="PS <psellars@gmail.com>"

RUN apk add --no-cache \
    curl=7.69.1-r0 \
    git=2.26.2-r0 \
    openssh-client=8.3_p1-r0 \
    rsync=3.1.3-r3

ENV VERSION 0.64.0

WORKDIR /tmp

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN curl -L \
      https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_linux-64bit.tar.gz \
      | tar -xz \
    && mv hugo /usr/local/bin/hugo \
    && curl -L \
      https://bin.equinox.io/c/dhgbqpS8Bvy/minify-stable-linux-amd64.tgz | tar -xz \
    && mv minify /usr/local/bin/ \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo

WORKDIR /src

EXPOSE 1313

ENTRYPOINT ["hugo", "server", "-w", "--bind=0.0.0.0"]
