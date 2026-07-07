#!/usr/bin/env bash
# 在 VPS 上执行的部署脚本（由 CD 通过 SSH 调用，也可手动运行）。
#
#   echo "$GHCR_TOKEN" | ./deploy.sh <image-tag> <ghcr-user>
#
# <image-tag>  要部署的镜像 tag，如 sha-abc123…（写入 .env 持久化，重启/手动 up 不漂移）
# <ghcr-user>  GHCR 登录用户名；token 从 stdin 读入，不落盘、不进 argv
set -euo pipefail

IMAGE_TAG=${1:?usage: echo TOKEN | deploy.sh <image-tag> <ghcr-user>}
GHCR_USER=${2:?usage: echo TOKEN | deploy.sh <image-tag> <ghcr-user>}

cd /srv/onecode

docker login ghcr.io -u "$GHCR_USER" --password-stdin

# 把本次部署的 tag 固化进 .env，保证之后手动 `docker compose up -d` 也用同一版本
if grep -q '^API_IMAGE_TAG=' .env; then
	sed -i "s|^API_IMAGE_TAG=.*|API_IMAGE_TAG=${IMAGE_TAG}|" .env
else
	echo "API_IMAGE_TAG=${IMAGE_TAG}" >>.env
fi

docker compose pull --quiet
docker compose up -d --wait --wait-timeout 300

docker logout ghcr.io
docker image prune -f >/dev/null

echo "deployed ${IMAGE_TAG}"
