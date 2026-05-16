$version = (Get-Content .nvmrc).Trim()

if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    Write-Host "nvm for Windows is not installed." -ForegroundColor Red
    Write-Host "Install from: https://github.com/coreybutler/nvm-windows/releases" -ForegroundColor Yellow
    exit 1
}

# Save current version before switching
$current = node --version 2>$null
if ($current) {
    ($current -replace '^v', '') | Set-Content .nvm-prev
}

$installed = nvm list 2>&1 | Select-String -SimpleMatch $version

if (-not $installed) {
    Write-Host "Node.js $version is not installed. Installing..." -ForegroundColor Yellow
    nvm install $version
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to install Node.js $version." -ForegroundColor Red
        exit 1
    }
}

nvm use $version
