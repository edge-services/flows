#!/bin/bash
export APP_VERSION=1.0.0
export ARCH=arm64v8
export NODE_VERSION=12.22.1
export OS=alpine

echo "#########################################################################"
echo "Build EdgeFlows Service version: ${APP_VERSION} for ${ARCH}"
echo "#########################################################################"

# sudo docker buildx build \
#   --push -t sinny777/security_arm64:0.0.1 \
#   --platform=linux/arm64 .

sudo docker buildx build --rm  \
    --build-arg ARCH=${ARCH} \
    --build-arg VERSION=${APP_VERSION} \
    --build-arg NODE_VERSION=${NODE_VERSION} \
    --build-arg OS=${OS} \
    --build-arg TAG_SUFFIX=${TAG_SUFFIX} \
    --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
    --file Dockerfile.alpine \
    --tag sinny777/edge-flows:${APP_VERSION} \
    --platform=linux/arm64v8 --push .

# sudo docker build --rm  \
#     --build-arg BUILD_DATE="$(date +"%Y-%m-%dT%H:%M:%SZ")" \
#     --build-arg NODE_VERSION=12.22.1 \
#     --build-arg TAG_SUFFIX=${APP_VERSION} \
#     --file Dockerfile.custom \
#     --tag sinny777/edge-gateway_${ARCH}:${APP_VERSION} .