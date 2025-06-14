# 🖥️ VSCode Server (code-server) in Docker

This project provides a ready-to-use Dockerized [code-server](https://github.com/coder/code-server) setup running on Ubuntu 22.04, with support for automatic VSIX extension downloads and non-root user configuration.

## ✨ Features

* 🐗 Based on `ubuntu:22.04`
* 🔐 Runs as non-root `coder` user with sudo access
* 🧩 Automatically installs VS Code extensions from a list of VSIX URLs
* 📁 Persistent volume for settings and projects
* 🚪 Exposes `code-server` on port `8080`
* 🔄 Auto-enables installed extensions in `settings.json`

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Cairnstew/vscode-server.git
cd vscode-server
```

### 2. Add Your Extensions

Update `extensions.txt` with one VSIX URL per line. Example:

```
https://github.com/EmmyLua/VSCode-EmmyLua/releases/download/0.2.1/emmylua-0.2.1.vsix
https://github.com/trixnz/vscode-lua/releases/download/v0.12.4/vscode-lua-0.12.4.vsix
```

### 3. Start the Server

```bash
docker compose up --build -d
```

Access it at: [http://localhost:8080](http://localhost:8080)

🗱️ Default password is `changeme` — **you must change this in production** via the `PASSWORD` environment variable.

---

## 🔧 Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── extensions.txt             # List of VSIX extension URLs
└── scripts/
    ├── install-extensions.sh  # Downloads and installs extensions
    ├── add-extensions-user.sh # Enables extensions in settings.json
    └── entry.sh               # Entrypoint script to prepare the environment
```

---

## ⚙️ Environment Variables

| Variable   | Description                     | Default  |
| ---------- | ------------------------------- | -------- |
| `PASSWORD` | Password for code-server access | changeme |

---

## 🧩 How Extensions Work

1. On container startup:

   * `install-extensions.sh` downloads and verifies VSIX files from `extensions.txt`
   * Valid VSIX files are installed using `code-server --install-extension`
2. `add-extensions-user.sh` enables these extensions in the user `settings.json`

---

## 📁 Volumes

| Volume             | Path                                   | Purpose                         |
| ------------------ | -------------------------------------- | ------------------------------- |
| `code-server-data` | `/home/coder/.local/share/code-server` | Persistent user data            |
| Bind Mount         | `/home/coder/projects`                 | Your local `./projects/` folder |

---

## 🚩 Stopping the Server

```bash
docker compose down
```

To rebuild from scratch (e.g. after changing extensions):

```bash
docker compose down -v
docker compose up --build
```

---

## 🧪 Example VSIX Sources

* EmmyLua: [https://github.com/EmmyLua/VSCode-EmmyLua/releases](https://github.com/EmmyLua/VSCode-EmmyLua/releases)
* Trixnz Lua: [https://github.com/trixnz/vscode-lua/releases](https://github.com/trixnz/vscode-lua/releases)

---

## 📄 License

MIT License
