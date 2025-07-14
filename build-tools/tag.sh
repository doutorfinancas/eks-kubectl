#!/usr/bin/env bash
set -e

# Input validation
read -rp "Enter Kubernetes version number: " BUILD_TAG

echo "$BUILD_TAG"

docker buildx build \
--push \
--build-arg KUBERNETES_VERSION="$BUILD_TAG" \
--platform linux/arm64,linux/amd64 \
--tag "ghcr.io/doutorfinancas/eks-kubectl:$BUILD_TAG" --tag "ghcr.io/doutorfinancas/eks-kubectl:latest" \
-f "Dockerfile" "."
