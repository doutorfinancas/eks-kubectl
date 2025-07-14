#!/usr/bin/env bash

set -euo pipefail

readonly IMAGE_NAME='eks-kubectl:dev'

usage() {
    echo "Usage: $0 <in|out|check> <amd64|arm64> [kubernetes_version]" >&2
    exit 1
}

main() {
    if [ ! -s /dev/stdin ]; then
        echo 'Error: Payload stdin is empty' >&2
        exit 1
    fi

    local script="${1:-}"
    local arch="${2:-}"
    local k8s_version="${3:-$(curl -fLs --retry 3 https://dl.k8s.io/release/stable.txt)}" # * Uses latest stable version by default

    case "${script}" in
        in|out|check) ;;
        *) echo 'Error: Invalid script' >&2; usage ;;
    esac

    case "${arch}" in
        amd64|arm64) ;;
        *) echo 'Error: Invalid architecture' >&2; usage ;;
    esac

    local platform="linux/${arch}"

    echo "[debug.sh] Building for platform: ${platform} with Kubernetes ${k8s_version}"
    docker build --platform "${platform}" --build-arg KUBERNETES_VERSION="${k8s_version}" -t "${IMAGE_NAME}" .

    mkdir -p .tmp

    echo "[debug.sh] Running debug container on platform: ${platform} with Kubernetes ${k8s_version}"
    docker run --rm -i --platform "${platform}" \
        -v "${PWD}/.tmp:/tmp/resource" "${IMAGE_NAME}" \
        bash "${BASH_OPTS:-+x}" "/opt/resource/${script}" "/tmp/resource" <<< "$(cat)"
}

main "$@"
