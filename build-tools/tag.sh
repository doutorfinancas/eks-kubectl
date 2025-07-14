#!/usr/bin/env bash

set -euo pipefail

readonly IMAGE_REPO='ghcr.io/doutorfinancas/eks-kubectl'
readonly PLATFORMS='linux/amd64,linux/arm64'
readonly BASE_KUBECTL_URL='https://dl.k8s.io/release'

# Prompt user for desired minor version
read -rp 'Enter Kubernetes minor version (e.g., 1.30): ' k8s_version
readonly k8s_version

if [[ -z "${k8s_version}" ]]; then
    echo 'error: Kubernetes version cannot be empty' >&2
    exit 1
fi

if [[ ${k8s_version} =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "[tag.sh] Fetching latest patch for minor release ${k8s_version}..."
    build_tag=$(curl -fLs --retry 3 "${BASE_KUBECTL_URL}/stable-${k8s_version}.txt")
    build_tag="${build_tag#v}" # * Strip leading "v"

    if [[ -z "${build_tag}" ]]; then
        echo 'Error: Unable to determine Kubernetes stable version' >&2
        exit 1
    fi

    readonly build_tag

    echo "[tag.sh] Building and tagging with Kubernetes version: ${build_tag}"
else
    echo 'Error: Only minor versions (e.g., 1.30) are allowed. Do not include patch' >&2
     exit 1
fi

docker buildx build --push --no-cache \
    --build-arg KUBERNETES_VERSION="${build_tag}" \
    --platform "${PLATFORMS}" \
    --tag "${IMAGE_REPO}:${build_tag}" \
    --tag "${IMAGE_REPO}:latest" \
    -f Dockerfile .

echo "[tag.sh] Done. Image available as both ${IMAGE_REPO}:${build_tag} and ${IMAGE_REPO}:latest"
