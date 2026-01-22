<#
.SYNOPSIS
    Builds the Flutter web application and deploys it to a Cloudways server.

.DESCRIPTION
    This script builds the Flutter project for web (release mode) and deploys
    the artifacts to a specified Cloudways server using SCP.

.PARAMETER ServerHost
    The IP address of the Cloudways server.

.PARAMETER Username
    The SFTP/SSH username for the application.

.PARAMETER RemotePath
    The remote path to deploy to (e.g., public_html). 
    On Cloudways, this is usually absolute path like: /home/master/applications/<app_name>/public_html

.PARAMETER KeyFile
    (Optional) Path to the private SSH key file.

.PARAMETER SkipBuild
    (Optional) Skip the build step and just deploy existing artifacts.

.EXAMPLE
    .\deploy_web.ps1 -ServerHost "192.168.1.1" -Username "app_user" -RemotePath "/home/master/applications/xyz/public_html"
#>

param(
    [string]$ServerHost,
    [string]$Username,
    [string]$RemotePath,
    [string]$KeyFile,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

# Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Join-Path $ScriptDir "..\app"
$BuildDir = Join-Path $ProjectRoot "build\web"

# Load config from .env if present and args are missing
$EnvFile = Join-Path $ScriptDir ".env"
if (Test-Path $EnvFile) {
    Write-Host "Loading configuration from $EnvFile..." -ForegroundColor Cyan
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match "^([^#=]+)=(.*)$") {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            if (-not (Get-Variable -Name $name -ErrorAction SilentlyContinue)) {
                # Map env vars to params if not already set
                if ($name -eq "CLOUDWAYS_IP" -and -not $ServerHost) { $ServerHost = $value }
                if ($name -eq "CLOUDWAYS_USER" -and -not $Username) { $Username = $value }
                if ($name -eq "CLOUDWAYS_PATH" -and -not $RemotePath) { $RemotePath = $value }
                if ($name -eq "CLOUDWAYS_KEY" -and -not $KeyFile) { $KeyFile = $value }
            }
        }
    }
}

# Validation
if (-not $ServerHost -or -not $Username -or -not $RemotePath) {
    Write-Error "Missing required parameters: ServerHost, Username, or RemotePath. You can pass them as arguments or create a .env file in the scripts directory."
    exit 1
}

# 1. Build
if (-not $SkipBuild) {
    Write-Host "`n[1/2] Building Flutter Web App..." -ForegroundColor Green
    Push-Location $ProjectRoot
    
    try {
        & flutter build web --release --web-renderer auto
        if ($LASTEXITCODE -ne 0) { throw "Flutter build failed." }
    }
    finally {
        Pop-Location
    }
}
else {
    Write-Host "`n[1/2] Skipping Build..." -ForegroundColor Yellow
}

if (-not (Test-Path $BuildDir)) {
    Write-Error "Build directory not found: $BuildDir. Run without -SkipBuild first."
    exit 1
}

# 2. Deploy
Write-Host "`n[2/2] Deploying to $Username@$ServerHost..." -ForegroundColor Green

$Destination = "${Username}@${ServerHost}:${RemotePath}"
Write-Host "Copying files to $Destination..."

try {
    # Safe SCP deployment:
    # 1. We change to the build directory.
    # 2. We get the list of items (files/folders).
    # 3. We pass their names to scp.
    
    Push-Location $BuildDir
    try {
        $Items = Get-ChildItem
        if ($Items.Count -eq 0) {
            Write-Warning "Build directory is empty."
        }
        else {
            # Construct scp arguments
            $ScpArgs = @("-r")
            if ($KeyFile) {
                # Wrap keyfile in quotes if needed by passing as separate arg which powershell handles
                $ScpArgs += "-i", $KeyFile
            }
            # Add all file/folder names
            $ScpArgs += $Items.Name
            # Add destination
            $ScpArgs += $Destination
            
            Write-Host "Uploading $($Items.Count) items..."
            
            # Executing scp with array arguments lets PowerShell handle quoting
            & scp $ScpArgs
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "`nSuccess! Deployment completed." -ForegroundColor Green
            }
            else {
                Write-Error "SCP command failed with exit code $LASTEXITCODE"
            }
        }
    }
    finally {
        Pop-Location
    }
}
catch {
    Write-Error "Deployment failed: $_"
}
