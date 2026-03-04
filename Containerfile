# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

### BUILD OLLAMA WITH VULKAN BACKEND
## Multi-stage: compile Ollama from source against the same Mesa/Vulkan
## headers shipped in the base image so it stays in sync on daily rebuilds.

FROM ghcr.io/ublue-os/bluefin-dx:stable AS ollama-builder

ARG OLLAMA_VERSION=v0.12.9

RUN --mount=type=cache,dst=/var/cache \
    dnf5 -y install \
      golang cmake gcc-c++ git \
      vulkan-headers vulkan-loader-devel \
      glslang glslang-devel \
      spirv-tools spirv-tools-devel \
      glslc

RUN git clone --depth 1 --branch ${OLLAMA_VERSION} \
      https://github.com/ollama/ollama.git /build/ollama

WORKDIR /build/ollama

ENV CGO_ENABLED=1
ENV GOFLAGS="-buildvcs=false"
ENV GOPATH=/tmp/go
ENV GOCACHE=/tmp/go-cache

# Build CPU + Vulkan runners via CMake presets
# Remove ccache from PATH — ephemeral builder, and it races on the cache dir
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN cmake --preset CPU && \
    cmake --build --parallel --preset CPU && \
    cmake --install build --component CPU --strip

RUN cmake --preset Vulkan && \
    cmake --build --parallel --preset Vulkan && \
    cmake --install build --component Vulkan --strip

# Build the Go binary
RUN go build -trimpath -o dist/bin/ollama .

# Flatten into /out for COPY
RUN mkdir -p /out/bin && \
    cp dist/bin/ollama /out/bin/ && \
    cp -a dist/lib /out/

### FINAL IMAGE
FROM ghcr.io/ublue-os/bluefin-dx:stable

## Install Ollama into the immutable image layer.
## /opt is a symlink to /var/opt on ostree, so we install to /usr/lib/ollama
## and create a tmpfiles.d symlink for /opt/ollama compat (same pattern as 1Password).
COPY --from=ollama-builder /out/bin/ollama /usr/bin/ollama
COPY --from=ollama-builder /out/lib/ollama/ /usr/lib/ollama/
RUN printf 'L /opt/ollama - - - - /usr/lib/ollama\n' > /usr/lib/tmpfiles.d/ollama.conf

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
