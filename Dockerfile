ARG DISTRO=alpine
ARG DISTRO_VERSION=3.18

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VERSION}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG NITTER_VERSION

ENV NITTER_VERSION=${NITTER_VERSION:-"78cb405acd192ee9391c2739f9edeab49c3ce797"} \
    NITTER_REPO_URL=https://github.com/zedeus/nitter \
    ENABLE_NGINX=FALSE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_MODE=PROXY \
    NGINX_PROXY_URL=http://localhost:8080 \
    CONTAINER_NAME=nitter-app \
    IMAGE_NAME="tiredofit/nitter" \
    IMAGE_REPO_URL="https://github.com/tiredofit/nitter/"

COPY build-assets /

RUN source assets/functions/00-container && \
    set -x && \
    addgroup -S -g 2323 nitter && \
    adduser -D -S -s /sbin/nologin \
            -h /dev/null \
            -G nitter \
            -g "nitter" \
            -u 2323 nitter \
            && \
    \
    package update && \
    package upgrade && \
    package install .nitter-build-deps \
                    build-base \
                    git \
                    libsass-dev \
                    nim \
                    nimble \
                    pcre \
                    && \
    \
    package install .nitter-run-deps \
                    pcre \
                    && \
    \
    clone_git_repo "${NITTER_REPO_URL}" "${NITTER_VERSION}" && \
    set +e && \
    if [ -d "/build-assets/src" ] ; then cp -Rp /build-assets/src/* /usr/src/nitter/ ; fi; \
    if [ -d "/build-assets/scripts" ] ; then for script in /build-assets/scripts/*.sh; do echo "** Applying $script"; bash $script; done && \ ; fi ; \
    set -e && \
    nimble install -y --depsOnly && \
    nimble build -d:danger -d:lto -d:strip && \
    nimble scss && \
    nimble md && \
    mkdir -p /app && \
    cp -R /usr/src/nitter/{nitter,public} /app/ && \
    mkdir -p /assets/nitter/ && \
    cp -R nitter.example.conf /assets/nitter/ && \
    chown -R nitter:nitter /app && \
    package remove \
            .nitter-build-deps \
            && \
    \
    package cleanup && \
    rm -rf /build-assets/ && \
    rm -rf /usr/src/*

EXPOSE 8080

COPY install /
