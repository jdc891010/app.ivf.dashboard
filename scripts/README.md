# Deployment & Launch Scripts

This directory contains PowerShell scripts to help manage the deployment of the IVF Clinic Dashboard (Flutter Web) to Cloudways.

## 1. Setup

First, configure your deployment settings.

1.  Copy `.env.example` to `.env`:
    ```powershell
    Copy-Item .env.example .env
    ```
2.  Edit `.env` with your Cloudways details:
    - `CLOUDWAYS_IP`: Your server's public IP.
    - `CLOUDWAYS_USER`: Your SSH/SFTP username (Application or Master credentials).
    - `CLOUDWAYS_PATH`: The absolute path to your `public_html` folder on the server.
    - `CLOUDWAYS_KEY`: (Optional) Full path to your private SSH key file (e.g., `C:\Users\jdc\.ssh\id_rsa`). If omitted, you may be prompted for a password.

## 2. Deploy to Cloudways

Run the deployment script to build the app and upload it to your server.

```powershell
.\deploy_web.ps1
```

Or pass arguments directly:

```powershell
.\deploy_web.ps1 -ServerHost "1.2.3.4" -Username "master_user" -RemotePath "/home/master/applications/xyz/public_html"
```

**What it does:**
1.  Runs `flutter build web --release` in the `app` directory.
2.  Uses `scp` to copy the contents of `app/build/web` to your Cloudways server.

## 3. Launch Locally

To test the application locally in Chrome:

```powershell
.\launch_local.ps1
```

## 4. Linux / Cloudways Deployment (Persistent)

If you are logged into your Linux server (e.g., via SSH on Cloudways), you can use the bash scripts for a complete setup and persistent deployment using PM2.

### A. Install Requirements

This script installs NVM, Node.js, PM2, and the Flutter SDK.

```bash
chmod +x scripts/install_requirements.sh
./scripts/install_requirements.sh
source ~/.bashrc
```

### B. Launch & Persistent Deploy

This script builds the Flutter web app and uses PM2 to serve it. PM2 ensures the application stays running and restarts automatically if the server reboots.

```bash
chmod +x scripts/launch_app.sh
./scripts/launch_app.sh
```

**Common PM2 Commands:**
- `pm2 status`: View running processes.
- `pm2 logs ivf-dashboard`: View application logs.
- `pm2 stop ivf-dashboard`: Stop the application.

## Prerequisites

- **Flutter SDK**: Must be installed (handled by `install_requirements.sh` on Linux).
- **Node.js & PM2**: Required for persistent Linux deployment.
- **OpenSSH Client**: Required for `scp` from local machines.
