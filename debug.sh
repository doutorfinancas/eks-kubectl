#!/usr/bin/env bash

set -euo pipefail

if [ ! -s /dev/stdin ]; then
    echo "error: payload stdin is empty"
    exit 1
fi

script="${1:-}"

if [ -z "${script}" ]; then
    echo "error: please provide script in first argument [in, out, check]"
    exit 1
fi

docker build --platform linux/amd64 -t eks-kubectl:dev .
docker run --rm -i --platform linux/amd64 -v "${PWD}/.tmp:/tmp/resource" docker.io/library/eks-kubectl:dev \
    bash "${BASH_OPTS:-+x}" "/opt/resource/${script}" "/tmp/resource" <<< "$(cat)"
