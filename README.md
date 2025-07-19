# Code-Server Docker Setup

A lightweight, secure setup for running a web-based Visual Studio Code environment using **code-server** in a Docker container. Access a fully-featured VS Code instance from your browser, with persistent settings, extensions, and project files.

## Features

- **Base Image**: Ubuntu 22.04
- **User**: Non-root user (`coder`) for enhanced security
- **Port**: Configurable via `.env` (default: 8080)
- **Authentication**: Password-based access (set via `.env`)
- **Persistence**:
  - User settings and extensions stored in a Docker volume
  - Project files mounted from the host
- **Pre-installed Extensions**: Includes `ms-python.python` for Python development

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Project Structure

```
.
├── Dockerfile           # Container setup and code-server installation
├── docker-compose.yml   # Service configuration with port mapping and volumes
├── .env                # Environment variables (project name, port, password)
├── projects/           # Host directory for code, mounted to /home/coder/projects
└── scripts/
    └── entry.sh        # Entrypoint script to start code-server
```

## Setup Instructions

1. **Clone the Repository** (or create files manually):
   ```bash
   git clone <repository-url>
   cd code-server-docker
   ```

2. **Create the `.env` File**:
   - Copy `.env.example` to `.env`:
     ```bash
     cp .env.example .env
     ```
   - Edit `.env` with your desired settings:
     ```env
     COMPOSE_PROJECT_NAME=myproject
     PASSWORD=securepassword123
     PORT=8080
     ```
     - `COMPOSE_PROJECT_NAME`: Sets container and volume names
     - `PASSWORD`: Password for code-server access
     - `PORT`: Host port mapped to container's port 8080

3. **Build and Run the Container**:
   ```bash
   docker-compose up -d --build
   ```

4. **Access Code-Server**:
   - Open your browser and navigate to `http://localhost:8080` (or the port specified in `.env`).
   - Log in with the password from `.env` (e.g., `securepassword123`).

## Usage

- **Coding**: Place your code in the `projects/` directory on the host. It will appear in `/home/coder/projects` inside code-server.
- **Extensions**: The `ms-python.python` extension is pre-installed. Add more via the code-server UI or modify the `Dockerfile`.
- **Persistence**: User settings and extensions are stored in the `myproject_data` Docker volume.
- **Stopping the Container**:
  ```bash
  docker-compose down
  ```

## Security Notes

- The `coder` user has passwordless sudo access by default. For production, restrict sudo permissions in the `Dockerfile`.
- Avoid hardcoding `PASSWORD` in `.env`. Use Docker secrets or a vault for secure password management.

## License

This project is licensed under the [MIT License](LICENSE).
