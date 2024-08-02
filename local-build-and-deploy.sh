#!/bin/bash

set -e  # Exit on error

# Define the service and its directory
SERVICE="."

# Define the Docker image for the service
IMAGE="shadi-solution/portal"

# Define the Kubernetes deployment and namespace for the service
DEPLOYMENT="portal-depl"
NAMESPACE="shadi-solution"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if docker and kubectl commands are available
if ! command_exists docker; then
  echo "Error: docker is not installed or not in PATH."
  exit 1
fi

if ! command_exists microk8s kubectl; then
  echo "Error: microk8s kubectl is not installed or not in PATH."
  exit 1
fi

# Function to remove Docker images
remove_image() {
  echo "Removing Docker image..."
  docker rmi "$IMAGE" --force || true
}

# Function to build Docker image
build_image() {
  echo "Building Docker image..."
  docker build -t "$IMAGE" "$SERVICE"
}

# Function to save and import Docker image into MicroK8s
import_image_to_microk8s() {
  echo "Saving and importing Docker image into MicroK8s..."
  IMAGE_TAR="${IMAGE//\//_}.tar"
  docker save "$IMAGE" > "$IMAGE_TAR"
  microk8s ctr image import $IMAGE_TAR
  rm "$IMAGE_TAR"
}

# Function to restart the Kubernetes deployment
restart_deployment() {
  echo "Rolling out restart for deployment: $DEPLOYMENT"
  microk8s kubectl rollout restart deployments "$DEPLOYMENT" -n "$NAMESPACE"
  microk8s kubectl rollout status deployment "$DEPLOYMENT" -n "$NAMESPACE"
}
# Function to confirm action
confirm_action() {
  read -r -p "Remove Docker image? [y/N] " confirmation
  case "$confirmation" in
    [yY][eE][sS]|[yY]) ;;
    *) echo "Aborted."; exit 1 ;;
  esac
}

# Check if the user wants to remove the image first
if [ "$1" == "--clean" ]; then
  confirm_action
  remove_image
fi

# Build image and import it to MicroK8s
build_image
import_image_to_microk8s
restart_deployment

echo "Build and import process completed."
