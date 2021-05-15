FROM ubuntu:focal
RUN cd /tmp \
  && apt update \
  && DEBIAN_FRONTEND=noninteractive apt install -y pkg-config libtool autoconf automake g++ protobuf-compiler bison flex make libcppunit-dev python-protobuf python-numpy wget libprotobuf-dev libftdi-dev liblo-dev libmicrohttpd-dev libusb-1.0-0-dev uuid-dev libncurses-dev libprotoc-dev zlib1g-dev libprotobuf17 libftdi1 liblo7 libmicrohttpd12 libusb-1.0-0 uuid-runtime libncurses6 libprotoc17 zlib1g curl \
  && curl https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz -o ola-0.10.8.tar.gz -s \
  && tar -xzf ola-0.10.8.tar.gz \
  && cd ola-0.10.8 \
  && autoreconf -i \
  && ./configure --disable-root-check \
  && make \
  && make install \
  && apt autoremove --purge -y pkg-config libtool autoconf automake g++ protobuf-compiler bison flex make libcppunit-dev python-protobuf python-numpy wget libprotobuf-dev libftdi-dev liblo-dev libmicrohttpd-dev libusb-1.0-0-dev uuid-dev libncurses-dev libprotoc-dev zlib1g-dev curl \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd .. \
  && rm -rf ola-0.10.8 ola-0.10.8.tar.gz
ENTRYPOINT ["olad", "-l", "3"]
