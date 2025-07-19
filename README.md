Code-Server Docker Setup
This project sets up a web-based Visual Studio Code environment using code-server in a Docker container.
Overview

Base Image: Ubuntu 22.04
User: Non-root user coder
Port: 8080 (configurable via .env)
Authentication: Password-based (set via .env)
Persistence: User settings and extensions are stored in a Docker volume; project files are mounted from the host.
Extensions: Includes ms-python.python for Python development.

Prerequisites

Docker
Docker Compose

Project Structure
.
├── Dockerfile
├── docker-compose.yml
├── .env
└── scripts/
    └── entry.sh


Dockerfile: Defines the container setup, including code-server installation and user configuration.
docker-compose.yml: Configures the code-server service with port mapping and volumes.
.env: Environment variables for project name, port, and password.
scripts/entry.sh: Entrypoint script to start code-server.

Setup Instructions

Clone the Repository (or create the files manually):
git clone <repository-url>
cd <repository-directory>


Create the .env File:Copy the .env.example and edit the following content:
COMPOSE_PROJECT_NAME=myproject
PASSWORD=securepassword123
PORT=8080


COMPOSE_PROJECT_NAME: Sets the container and volume names.
PASSWORD: Password for accessing code-server.
PORT: Host port mapped to the container’s port 8080.

Build and Run the Container:
docker-compose up -d --build


Access Code-Server:

Open your browser and navigate to http://localhost:8080 (or the port specified in .env).
Log in with the password from the .env file (e.g., securepassword123).



Usage

Extensions: The Python extension (ms-python.python) is pre-installed. Install additional extensions via the code-server UI or define them in the Dockerfile.
Persistence: User settings and extensions persist in the myproject_data Docker volume.
Stopping the Container:docker-compose down


Security Notes

The coder user has passwordless sudo access. For production, restrict sudo permissions.
Avoid hardcoding the PASSWORD in .env. Use Docker secrets or a vault for secure password management.

License
This project is licensed under the MIT License.