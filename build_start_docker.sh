#!/bin/bash

# 检查是否提供了 VERSION 参数
if [ -z "$1" ]; then
    echo "错误: 请提供版本号参数 (VERSION)"
    echo "用法: $0 <VERSION>"
    echo "示例: $0 v1.0.0"
    exit 1
fi

VERSION=$1
IMAGE_NAME="nanobot:qiming-${VERSION}"
CONTAINER_NAME="nanobot-qiming"

echo ">>> 开始部署 nanobot, 版本: ${VERSION}"

# 1. 构建 Docker 镜像
echo ">>> 正在构建镜像: ${IMAGE_NAME}"
docker build -t "${IMAGE_NAME}" .
if [ $? -ne 0 ]; then
    echo "错误: 镜像构建失败"
    exit 1
fi

# 2. 删除已存在的同名容器 (如果存在)
# 使用 rm -f 强制删除，即使容器正在运行或不存在也不会报错中断
echo ">>> 正在删除旧容器: ${CONTAINER_NAME}"
docker rm -f "${CONTAINER_NAME}"

# 3. 启动新容器
echo ">>> 正在启动新容器: ${CONTAINER_NAME}"
docker run -dt \
    -v /home/aiops/project/.nanobot:/root/.nanobot \
    -p 18790:18790 \
    -p 30001:8000 \
    --name "${CONTAINER_NAME}" \
    "${IMAGE_NAME}" \
    gateway

if [ $? -eq 0 ]; then
    echo ">>> 部署成功! 容器 ${CONTAINER_NAME} 已启动."
    docker ps -f name="${CONTAINER_NAME}"
else
    echo "错误: 容器启动失败"
    exit 1
fi
