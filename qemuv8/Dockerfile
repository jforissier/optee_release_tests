FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y
RUN apt install -y \
    adb \
    acpica-tools \
    autoconf \
    automake \
    bc \
    bison \
    build-essential \
    ccache \
    cpio \
    cscope \
    curl \
    device-tree-compiler \
    e2tools \
    expect \
    fastboot \
    flex \
    ftp-upload \
    gawk \
    gdisk \
    git \
    help2man \
    libattr1-dev \
    libcap-ng-dev \
    libfdt-dev \
    libftdi-dev \
    libglib2.0-dev \
    libgmp3-dev \
    libhidapi-dev \
    libmpc-dev \
    libncurses5-dev \
    libpixman-1-dev \
    libslirp-dev \
    libssl-dev \
    libtinfo5 \
    libtool \
    libtool-bin \
    libusb-1.0-0-dev \
    make \
    mtools \
    netcat \
    ninja-build \
    python3-cryptography \
    python3-pip \
    python3-pyelftools \
    python3-serial \
    python-is-python3 \
    rsync \
    swig \
    texinfo \
    unzip \
    uuid-dev \
    wget \
    xalan \
    xdg-utils \
    xterm \
    xz-utils \
    zlib1g-dev
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo && chmod a+x /usr/bin/repo
ARG USER_ID
ARG USER_GID
RUN groupadd -g ${USER_GID} -o builder && \
    useradd -m -u ${USER_ID} -g ${USER_GID} -o builder
USER builder
ENV HOME /home/builder
WORKDIR /home/builder
# Build and install cross-compiler with BTI support in ~/x-tools/aarch64-unknown-linux-gnu/bin
RUN git clone https://github.com/crosstool-ng/crosstool-ng \
 && cd crosstool-ng \
 && ./bootstrap \
 && ./configure --enable-local \
 && make -j$(nproc) \
 && ./ct-ng aarch64-unknown-linux-uclibc \
 && sed -i '/CT_GCC_V_12/d' .config \
 && echo 'CT_GCC_V_12=y' >>.config \
 && sed -i 's/CT_GCC_VERSION=.*/CT_GCC_VERSION="12.3.0"/' .config \
 && echo 'CT_CC_GCC_EXTRA_CONFIG_ARRAY="--enable-standard-branch-protection"' >>.config \
 && echo 'CT_CC_GCC_CORE_EXTRA_CONFIG_ARRAY="--enable-standard-branch-protection"' >>.config \
 && ./ct-ng build.$(nproc)
RUN mkdir /home/builder/optee
WORKDIR /home/builder/optee
COPY TEE_Initial_Configuration-Test_Suite_v2_0_0_2-2017_06_09.7z .
RUN repo init -u https://github.com/OP-TEE/manifest.git -m qemu_v8.xml && repo sync -j10
WORKDIR /home/builder/optee/build
RUN make -j2 toolchains
RUN make clang-toolchains
ENV PATH=$PATH:/home/builder/optee/clang-12.0.0/bin
ENV CFG_TEE_CORE_LOG_LEVEL=2
ENV GP_PACKAGE=/home/builder/optee/TEE_Initial_Configuration-Test_Suite_v2_0_0_2-2017_06_09.7z
ENV CFG_PKCS11_TA=y
ENV CFG_USER_TA_TARGET_pkcs11=ta_arm64
ENV CFG_ENABLE_EMBEDDED_TESTS=y
ENV DUMP_LOGS_ON_ERROR=y
