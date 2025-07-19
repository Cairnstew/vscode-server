FROM ubuntu:22.04

# --- Environment Variables ---
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    USER_NAME=coder \
    USER_HOME=/home/coder \
    CODE_SERVER_PORT=8080 \
    EXT_SCRIPT_DIR=/usr/local/bin

# Install necessary packages, including Python 3 and pip
RUN apt-get update && \
    apt-get install -y curl gnupg ca-certificates jq build-essential \
    libssl-dev libffi-dev git wget unzip sudo python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Install code-server ---
RUN curl -fsSL https://code-server.dev/install.sh | sh

# --- Create User ---
RUN useradd -m -s /bin/bash ${USER_NAME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p ${USER_HOME}/.local/share/code-server/User && \
    mkdir -p ${USER_HOME}/.config && \
    mkdir -p ${USER_HOME}/.cache && \
    chown -R ${USER_NAME}:${USER_NAME} ${USER_HOME}/.local ${USER_HOME}/.config ${USER_HOME}/.cache

# --- Copy Scripts ---
COPY scripts/entry.sh ${EXT_SCRIPT_DIR}/entry.sh

# --- Permissions ---
RUN chmod +x ${EXT_SCRIPT_DIR}/*.sh

# --- Switch to Non-Root User ---
USER ${USER_NAME}
WORKDIR ${USER_HOME}

RUN mkdir -p ${USER_HOME}/projects && chown ${USER_NAME}:${USER_NAME} ${USER_HOME}/projects
# --- Download Extensions ---
RUN code-server --install-extension ms-python.python
# code-server --install-extension other.extension

RUN if [ -f .local/share/code-server/User/settings.json ]; then \
        jq '. + {"python.defaultInterpreterPath": "/usr/bin/python3"}' .local/share/code-server/User/settings.json > /tmp/settings.json && \
        mv /tmp/settings.json .local/share/code-server/User/settings.json; \
    else \
        echo '{"python.defaultInterpreterPath": "/usr/bin/python3"}' > .local/share/code-server/User/settings.json; \
    fi

# --- Expose Port ---
EXPOSE ${CODE_SERVER_PORT}

# --- Entrypoint and Default CMD ---
ENTRYPOINT ["bash", "/usr/local/bin/entry.sh"]
CMD ["--bind-addr", "0.0.0.0:8080", "--auth", "password"]
