FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

# Install necessary packages, including Python 3 and pip
RUN apt-get update && \
    apt-get install -y curl gnupg ca-certificates jq build-essential \
    libssl-dev libffi-dev git wget unzip sudo python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create a non-root user with sudo access and setup their home directory
RUN useradd -m -s /bin/bash coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/coder/.local/share/code-server/User && \
    mkdir -p /home/coder/.config && \
    mkdir -p /home/coder/.cache && \
    chown -R coder:coder /home/coder/.local /home/coder/.config /home/coder/.cache

# Copy scripts
COPY scripts/install-extensions.sh /usr/local/bin/install-extensions.sh
COPY scripts/add-extensions-user.sh /usr/local/bin/add-extensions-user.sh
COPY scripts/entry.sh /usr/local/bin/entry.sh
COPY extensions.txt /home/coder/extensions.txt

# Set executable permissions
RUN chmod +x /usr/local/bin/*.sh

# Switch to non-root user
USER coder
WORKDIR /home/coder

RUN mkdir -p /home/coder/projects

RUN /usr/local/bin/install-extensions.sh

RUN /usr/local/bin/add-extensions-user.sh

# Set Python as the default interpreter in code-server settings
RUN if [ -f .local/share/code-server/User/settings.json ]; then \
        jq '. + {"python.defaultInterpreterPath": "/usr/bin/python3"}' .local/share/code-server/User/settings.json > /tmp/settings.json && \
        mv /tmp/settings.json .local/share/code-server/User/settings.json; \
    else \
        echo '{"python.defaultInterpreterPath": "/usr/bin/python3"}' > .local/share/code-server/User/settings.json; \
    fi

# Expose code-server port
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entry.sh"]
CMD ["--bind-addr", "0.0.0.0:8080", "--auth", "password"]