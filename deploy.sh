#!/usr/bin/env bash

# Get environment variables
# Get branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
else
  # Linux and others
  REPO_NAME=$(basename -s .git $(git config --get remote.origin.url))
fi

APP_NAME=${REPO_NAME}
NODE_ENV=${BRANCH_NAME}

echo "Loading environment variables..."

# Load environment variables from .env file
if [ -f ".env.${PORT}" ]; then
  echo "Loading from .env.${PORT}"
  set -a
  if [[ "$OSTYPE" == "darwin"* ]]; then
    source .env.${PORT}
  else
    . .env.${PORT}
  fi
  set +a
elif [ -f ".env" ]; then
  echo "Loading from .env"
  set -a
  if [[ "$OSTYPE" == "darwin"* ]]; then
    source .env
  else
    . .env
  fi
  set +a
fi

# Set default port if not defined in .env
PORT=${PORT:-4001}
echo "Using PORT: ${PORT}"

# Construct container and image names
CONTAINER_NAME="${APP_NAME}-${NODE_ENV}"
IMAGE_NAME="${APP_NAME}-${NODE_ENV}"

echo "Starting container with name: ${CONTAINER_NAME}"
echo "Using image: ${IMAGE_NAME}"

# Stop and remove existing container if it exists
docker stop "${CONTAINER_NAME}" 2>/dev/null || true
docker rm "${CONTAINER_NAME}" 2>/dev/null || true

# Build and run container
docker build -t "${IMAGE_NAME}" . && \
docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart always \
  -p "${PORT}:${PORT}" \
  "${IMAGE_NAME}" && \
docker logs -f "${CONTAINER_NAME}"