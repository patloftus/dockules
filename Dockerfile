FROM debian:bookworm AS builder

ARG HERCULES_VERSION=4.9.1
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    autoconf \
    automake \
    libtool \
    flex \
    bison \
    m4 \
    pkg-config \
    ca-certificates \
    zlib1g-dev \
    libbz2-dev \
    libltdl-dev \
 && rm -rf /var/lib/apt/lists/*


WORKDIR /src

RUN git clone \
    --depth 1 \
    --branch Release_${HERCULES_VERSION} \
    https://github.com/SDL-Hercules-390/hyperion.git \


WORKDIR /src/hyperion

RUN ./configure \
        --enable-cckd-bzip2 && \
    make -j$(nproc) && \
    make install DESTDIR=/install


FROM debian:bookworm-slim


RUN apt-get update && apt-get install -y \
    zlib1g \
    libbz2-1.0 \
    libltdl7 \
 && rm -rf /var/lib/apt/lists/*


RUN useradd \
    --create-home \
    --uid 1000 \
    hercules


COPY --from=builder /install/ /

COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/healthcheck.sh /healthcheck.sh


RUN chmod +x \
    /entrypoint.sh \
    /healthcheck.sh


USER hercules

WORKDIR /hercules

HEALTHCHECK \
    CMD /healthcheck.sh


ENTRYPOINT ["/entrypoint.sh"]
