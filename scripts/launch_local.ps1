<#
.SYNOPSIS
    Runs the Flutter web application locally.

.DESCRIPTION
    This script runs the Flutter app in Chrome for local development/testing.
#>

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Join-Path $ScriptDir "..\app"

Write-Host "Starting Flutter Web locally..." -ForegroundColor Green

Push-Location $ProjectRoot
try {
    & flutter run -d chrome
}
finally {
    Pop-Location
}
