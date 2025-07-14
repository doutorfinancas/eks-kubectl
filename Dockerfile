FROM alpine:3.17.1

LABEL org.opencontainers.image.source=https://github.com/doutorfinancas/eks-kubectl

ARG KUBERNETES_VERSION
RUN test -n "${KUBERNETES_VERSION}" # * Ensures KUBERNETES_VERSION is supplied
ARG AWS_CLI_VER=2.8.4
ARG TARGETARCH

RUN apk add jq curl gcompat zip bash aws-cli

RUN echo "curl -s -LO https://dl.k8s.io/release/v${KUBERNETES_VERSION}/bin/linux/${TARGETARCH}/kubectl"
# Install kubectl
RUN curl -s -LO https://dl.k8s.io/release/v${KUBERNETES_VERSION}/bin/linux/${TARGETARCH}/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

COPY assets/ /opt/resource/
RUN chmod +x /opt/resource/*
