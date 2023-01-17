FROM alpine:3.17.1

LABEL org.opencontainers.image.source https://github.com/doutorfinancas/eks-kubectl

ARG KUBERNETES_VERSION=v1.23.0
ARG AWS_CLI_VER=2.8.4

RUN apk add jq curl gcompat zip bash aws-cli

# Install kubectl
RUN curl -s -LO https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

COPY assets/ /opt/resource/
RUN chmod +x /opt/resource/*
