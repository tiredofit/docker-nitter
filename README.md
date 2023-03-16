# github.com/tiredofit/nitter

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/nitter?style=flat-square)](https://github.com/tiredofit/nitter/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-nitter/main.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-nitter/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/rspamd.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/nitter/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/rspamd.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/nitter/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker Image for [Nitter] (https://nitter.net), An alternative front-end to Twitter

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [Nitter Options](#nitter-options)
    - [Cache Options](#cache-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)
* [Redis](https://github.com/tiredofit/docker-redis) service available

## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/nitter)

```bash
docker pull docker.io/tiredofdit/nitter:(imagetag)
```
Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-nitter/pkgs/container/docker-nitter) 
 
```
docker pull ghcr.io/tiredofit/docker-nitter:(imagetag)
``` 

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description                           |
| --------- | ------------------------------------- |
| /config   | (optional) Custom Configuration Files |

* * *
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |


#### Container Options

| Name           | Description                               | Default       |
| -------------- | ----------------------------------------- | ------------- |
| `CONFIG_FILE`  | Config file name (if `SETUP_MODE=MANUAL`) | `nitter.conf` |
| `CONFIG_PATH`  | Config file name (if `SETUP_MODE=MANUAL`) | `/config/`    |
| `ENABLE_NGINX` | Use NGINX as a proxy to Nitter            | `FALSE`       |
| `LISTEN_PORT`  | Default Listen Port                       | `8080`        |
| `SETUP_MODE`   | `AUTO` or `MANUAL` configuration          | `AUTO`        |

#### Nitter Options

| Name                          | Description                                       | Default               |
| ----------------------------- | ------------------------------------------------- | --------------------- |
| `APP_DEBUG`                   | Enable Application Debug Mode                     | `FALSE`               |
| `APP_SECRET`                  | HMAC Key                                          | random                |
| `DEFAULT_THEME`               | Default Theme                                     | `Nitter`              |
| `DEFAULT_AUTOPLAY_GIF`        | Autoplay GIFs                                     | `TRUE`                |
| `DEFAULT_BIDIRECTIONAL_TEXT`  | Enable BiDirectional Text                         | `FALSE`               |
| `DEFAULT_DEFAULT_MUTE_VIDEOS` | Mute Videos                                       | `FALSE`               |
| `DEFAULT_HIDE_BANNER`         | Hide Profile Banner                               | `FALSE`               |
| `DEFAULT_HIDE_PINS`           | Hide Pinned Tweets                                | `FALSE`               |
| `DEFAULT_HIDE_REPLIES`        | Hide Replies                                      | `FALSE`               |
| `DEFAULT_HIDE_TWEET_STATS`    | Hide Stats                                        | `FALSE`               |
| `DEFAULT_HLS_PLAYBACK`        | Media Playback                                    | `FALSE`               |
| `DEFAULT_INFINITE_SCROLL`     | Infinite Scrolling                                | `FALSE`               |
| `DEFAULT_MP4_PLAYBACK`        | Use MP4 for Playback                              | `FALSE`               |
| `DEFAULT_PROXY_VIDEOS`        | Proxy Videos                                      | `TRUE`                |
| `DEFAULT_SQUARE_AVATARS`      | Use Square Avatars                                | `FALSE`               |
| `DEFAULT_STICKY_PROFILE`      | Make profile header Sticky                        | `FALSE`               |
| `ENABLE_HTTPS`                | Enable HTTPS Cookie Mode                          | `TRUE`                |
| `ENABLE_RSS`                  | Enable RSS Feeds                                  | `FALSE`               |
| `HTTP_MAX_CONNECTIONS`        | Maximum amount of connections                     | `100`                 |
| `LISTEN_PORT`                 | Listen Port                                       | `8080`                |
| `PROXY_URL`                   | If using a upstream proxy enter here              | ``                    |
| `PROXY_AUTH`                  | If using a upstream proxy enter auth details here | ``                    |
| `SITE_HOSTNAME`               | Sites Hostname                                    | `nitter.net`          |
| `SITE_TITLE`                  | Title in Browser                                  | `Tiredof I.T! Nitter` |
| `STATIC_PATH`                 | Path for Static Assets                            | `/app/public/`        |
| `TOKEN_COUNT_MINIMUM`         | API Counts                                        | `10`                  |
| `URL_USE_BASE64`              | Should media utilize Base64 encoding              | `FALSE`               |

#### Cache Options

| Name                    | Description                              | Default |
| ----------------------- | ---------------------------------------- | ------- |
| `CACHE_LIST`            | How long to cache lists info (keep high) | `240`   |
| `CACHE_RSS`             | Hoe long to cache RSS Feeds              | `10`    |
| `REDIS_CONNECTION_MAX`  | Maximum Connections to Redis             | `30`    |
| `REDIS_CONNECTION_POOL` | Connection Pools                         | `20`    |
| `REDIS_PORT`            | Redis Port                               | `6379`  |
| `REDIS_HOST`            | Redis Hostname                           | ``      |
| `REDIS_PASS`            | Redis Password                           | ``      |

### Networking

| Port | Protocol | Description        |
| ---- | -------- | ------------------ |
| 8080 | tcp      | Nitter Application |

## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* <https://nitter.net>
