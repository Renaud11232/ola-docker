FROM alpine:3.15 AS olabuilder

RUN cd /tmp && \
  apk add --no-cache \
    wget \
    autoconf \
    automake \
    libtool \
    g++ \
    bison \
    flex \
    file \
    pkgconfig \
    util-linux-dev \
    cppunit-dev \
    protobuf-dev \
    make \
    libmicrohttpd-dev \
    ncurses-dev \
    protoc \
    libftdi1-dev \
    libusb-dev \
    linux-headers \
  && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing liblo-dev \
  && cd /tmp \
  && wget https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz \
  && tar xzf ola-0.10.8.tar.gz \
  && mv ola-0.10.8 ola \
  && cd ola \
  && ./configure --enable-all-plugins --disable-static \
  && make \
  && make install

FROM alpine:3.15

COPY --from=olabuilder /usr/local /usr/local

RUN apk add --no-cache \
    libuuid \
    libmicrohttpd \
    libprotobuf \
    ncurses-libs \
    libftdi1 \
    libusb \
  && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing liblo \
  && addgroup -S olad \
  && adduser -S olad -G olad

USER olad

ENTRYPOINT ["olad", "-l", "3"]
