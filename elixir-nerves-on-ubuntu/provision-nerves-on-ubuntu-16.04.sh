#!/bin/bash
# curl -fSL -o "provision-nerves-on-ubuntu-16.04.sh" "https://raw.githubusercontent.com/chgeuer/mybookmarks/master/elixir-nerves-on-ubuntu/provision-nerves-on-ubuntu-16.04.sh"


# 
# This long sequence of Erlang / Elixir installation comes from the Docker files:
#
# https://github.com/c0b/docker-erlang-otp/blob/9be249effe93e3c61fa0749078e55ef8d050a16e/19/Dockerfile
# https://github.com/c0b/docker-elixir/blob/ded1bb8a2438374853a5a94a3ef1171d081dacff/1.3/Dockerfile
#

LANG=C.UTF-8
OTP_VERSION="19.3"
OTP_DOWNLOAD_SHA256="..."
REBAR_VERSION="2.6.4"
REBAR_DOWNLOAD_SHA256="577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07"
REBAR3_VERSION="3.3.1"
REBAR3_DOWNLOAD_SHA256="1042ffc90a723f57b9d5a6e3858c33e9c5230fe9ef0c51fafd6ce63618b4afe9"
ELIXIR_VERSION="v1.4.2"
ELIXIR_DOWNLOAD_SHA256="..."
NERVES_VERSION="0.7.0"
NERVES_DOWNLOAD_SHA256="31b799f288c3deac9ef675e9a9da3d931c7f8cb3d7f9f6725a906846d0baea09"

apt-get update
apt-get install -y --no-install-recommends libodbc1 libsctp1 unixodbc-dev libsctp-dev
apt-get install -y autoconf gcc g++ make cmake unzip git bc m4 libncurses5-dev libncursesw5-dev xsltproc fop openssl libssl-dev unixodbc-dev libwxbase3.0-dev libwxgtk3.0-dev libgtk2.0-dev libqt4-opengl-dev openjdk-9-jdk-headless

########################################
# Erlang/OTP
########################################

OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz"
curl -fSL -o "OTP-${OTP_VERSION}.tar.gz" "$OTP_DOWNLOAD_URL"
echo "$OTP_DOWNLOAD_SHA256 OTP-${OTP_VERSION}.tar.gz" | sha256sum -c -
mkdir -p /usr/src/otp-src
tar -xzf "OTP-${OTP_VERSION}.tar.gz" -C /usr/src/otp-src --strip-components=1
cd /usr/src/otp-src
./otp_build autoconf
./configure --enable-sctp
make -j$(nproc)
make install
find /usr/local -name examples | xargs rm -rf
cd ~
rm -rf /usr/src/otp-src /var/lib/apt/lists/*

REBAR_DOWNLOAD_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION}.tar.gz"
mkdir -p /usr/src/rebar-src
curl -fSL -o "rebar-src-${REBAR_VERSION}.tar.gz" "$REBAR_DOWNLOAD_URL"
echo "$REBAR_DOWNLOAD_SHA256 rebar-src-${REBAR_VERSION}.tar.gz" | sha256sum -c -
tar -xzf "rebar-src-${REBAR_VERSION}.tar.gz" -C /usr/src/rebar-src --strip-components=1
cd /usr/src/rebar-src
./bootstrap
install -v ./rebar /usr/local/bin/
cd ~
rm -rf /usr/src/rebar-src

mkdir -p /usr/src/rebar3-src
REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz"
curl -fSL -o "rebar3-src-${REBAR3_VERSION}.tar.gz" "$REBAR3_DOWNLOAD_URL"
echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src-${REBAR3_VERSION}.tar.gz" | sha256sum -c -
tar -xzf "rebar3-src-${REBAR3_VERSION}.tar.gz" -C /usr/src/rebar3-src --strip-components=1
cd /usr/src/rebar3-src
HOME=$PWD ./bootstrap
install -v ./rebar3 /usr/local/bin/
cd ~
rm -rf /usr/src/rebar3-src

########################################
# Elixir
########################################

ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip"
curl -fSL -o "elixir-precompiled-${ELIXIR_VERSION}.zip" $ELIXIR_DOWNLOAD_URL
echo "$ELIXIR_DOWNLOAD_SHA256 elixir-precompiled-${ELIXIR_VERSION}.zip" | sha256sum -c -
unzip -d /usr/local "elixir-precompiled-${ELIXIR_VERSION}.zip"
rm -rf /var/lib/apt/lists/*

########################################
# Nerves Project
########################################

cd ~
NERVES_DOWNLOAD_URL="https://github.com/nerves-project/nerves_system_br/archive/v${NERVES_VERSION}.tar.gz"
curl -fSL -o "nerves_system_br-${NERVES_VERSION}.tar.gz" $NERVES_DOWNLOAD_URL
echo "$NERVES_DOWNLOAD_SHA256 nerves_system_br-${NERVES_VERSION}.tar.gz" | sha256sum -c -
mkdir ~/nerves_system_br
tar -xzf "nerves_system_br-${NERVES_VERSION}.tar.gz" -C ~/nerves_system_br --strip-components=1

cd ~
git clone https://github.com/nerves-project/nerves_system_rpi3.git
cd ~/nerves_system_rpi3
~/nerves_system_br/create-build.sh ./nerves_defconfig build
cd ~/nerves_system_rpi3/build
make

cd ~
mix local.hex --force
mix local.rebar --force
mix archive.install https://github.com/nerves-project/archives/raw/master/nerves_bootstrap.ez --force



export MIX_ENV=prod
export NERVES_TARGET=rpi3


cd ~
git clone https://github.com/nerves-project/nerves-examples.git
cd ~/nerves-examples/hello_wifi
source ~/nerves_system_rpi3/build/nerves-env.sh
mix do deps.get
mix do firmware
