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

## Prerequisites

- **Flutter SDK**: Must be installed and in your PATH.
- **OpenSSH Client**: Included in Windows 10/11. Required for `scp` commands.
