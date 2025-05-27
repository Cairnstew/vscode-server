FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    build-essential \
    python3 \
    python3-pip \
    sudo \
    git \
    wget \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*



# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh


# Create a non-root user with sudo access
RUN useradd -m -s /bin/bash coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER coder
WORKDIR /home/coder


# Install multiple VSIX extensions
RUN wget -O python.vsix https://demystifying-javascript.gallery.vsassets.io/_apis/public/gallery/publisher/demystifying-javascript/extension/python-extensions-pack/1.0.3/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage && \
    code-server --install-extension python.vsix && \
    rm python.vsix && \
    \
    wget -O dracula.vsix https://dracula-theme.gallery.vsassets.io/_apis/public/gallery/publisher/dracula-theme/extension/theme-dracula/2.25.1/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage && \
    code-server --install-extension dracula.vsix && \
    rm dracula.vsix



# Expose code-server port
EXPOSE 8080


# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password"]
