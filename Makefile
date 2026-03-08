.PHONY: help build-all build-hub build-pytorch build-tensorflow clean build-alphatauri

help:
	@echo "JupyterHub Docker Image Build Commands"
	@echo ""
	@echo "Usage:"
	@echo "  make build-all        - Build all images (hub + notebooks)"
	@echo "  make build-hub        - Build JupyterHub server image only"
	@echo "  make build-pytorch    - Build NVIDIA PyTorch notebook image"
	@echo "  make build-tensorflow - Build NVIDIA TensorFlow notebook image"
	@echo "  make build-alphatauri - Build JupyterHub Alpha server image"
	@echo "  make build-bolzano    - Build JupyterHub Bolzano server image"
	@echo "  make push-alphatauri  - Push JupyterHub Alpha server image"
	@echo "  make push-bolzano     - Push JupyterHub Bolzano server image"
	@echo "  make clean            - Remove old images (use with caution)"
	@echo ""

build-all: build-hub build-pytorch build-tensorflow
	@echo "✓ All images built successfully"

build-hub:
	@echo "Building JupyterHub server image..."
	docker compose build hub

build-pytorch:
	@echo "Building NVIDIA PyTorch notebook image..."
	docker build -t jupyterhub-nvidia-pytorch:latest images/nvidia-pytorch/

build-tensorflow:
	@echo "Building NVIDIA TensorFlow notebook image..."
	docker build -t jupyterhub-nvidia-tensorflow:latest images/nvidia-tensorflow/

build-alphatauri:
	@echo "Building JupyterHub Alpha server image..."
	docker build -t xcurvnubaim/jupyterhub-images-alphatauri:latest images/alphatauri/

push-alphatauri:
	docker push xcurvnubaim/jupyterhub-images-alphatauri:latest

build-bolzano:
	@echo "Building JupyterHub Bolzano server image..."
	docker build -t xcurvnubaim/jupyterhub-bolzano:latest images/bolzano/

push-bolzano:
	docker push xcurvnubaim/jupyterhub-bolzano:latest

clean:
	@echo "Cleaning up old images..."
	@echo "Warning: This will remove dangling images"
	docker image prune -f
