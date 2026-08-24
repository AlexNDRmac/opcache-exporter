# A multi-stage build producing a distroless container image
# containing only the statically linked opcache_exporter binary.

# --- Builder stage ---

# Run the builder on the host architecture; Go cross-compiles natively
# via GOOS/GOARCH, so there is no need for QEMU emulation.
FROM --platform=$BUILDPLATFORM golang:1.27-bookworm AS builder

ARG TARGETOS=linux
ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && update-ca-certificates
WORKDIR /app

# Cache module downloads separately from the build so source changes
# do not re-download dependencies.
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY . .

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build \
    -trimpath \
    -o ./bin/opcache_exporter ./cmd/exporter

# --- Final stage ---
FROM gcr.io/distroless/static-debian13:nonroot

ARG VERSION
ARG fcgi_uri
ENV VERSION=${VERSION:-1.0.0}
ENV FCGI_URI=${fcgi_uri:-}

LABEL org.opencontainers.image.source="https://github.com/AlexNDRmac/opcache-exporter" \
      org.opencontainers.image.description="Prometheus exporter for PHP OPCache" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.title="opcache-exporter" \
      org.opencontainers.image.url="https://github.com/AlexNDRmac/opcache-exporter" \
      org.opencontainers.image.version="${VERSION}"

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/bin/opcache_exporter /usr/bin/opcache_exporter

EXPOSE 9101

CMD ["/usr/bin/opcache_exporter", "--opcache.fcgi-uri=${FCGI_URI}"]
