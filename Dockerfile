FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-pip \
    git \
    wget \
    unzip \
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create a non-root user with sudo access
RUN useradd -m -s /bin/bash coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER coder
WORKDIR /home/coder

# Optional: Install common VS Code extensions (preinstalled)
# RUN code-server --install-extension ms-python.python

# Expose code-server port
EXPOSE 8080

# Set default password (override via env var at runtime)
ENV PASSWORD=changeme

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password"]
