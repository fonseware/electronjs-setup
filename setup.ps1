Clear-Host
$repoUrl = "https://github.com/fonseware/electronjs-setup.git"
$repoFolder = "$PSScriptRoot\electronjs-setup"
$versionFileUrl = "https://raw.githubusercontent.com/fonseware/electronjs-setup/main/version.txt"
$localVersionFile = "$repoFolder\version.txt"

# Ensure Git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed. Please install Git and try again."
    exit 1
}

# Download latest version.txt from GitHub
$tempVersionFile = "$env:TEMP\version.txt"
Invoke-WebRequest -Uri $versionFileUrl -OutFile $tempVersionFile -ErrorAction SilentlyContinue

if (!(Test-Path $tempVersionFile)) {
    Write-Host "Failed to download version.txt. Running setup normally."
    & "$repoFolder\electronjs-setup.ps1"
    exit 0
}

# Read versions
$remoteVersion = Get-Content $tempVersionFile -Raw
$localVersion = if (Test-Path $localVersionFile) { Get-Content $localVersionFile -Raw } else { "" }

# If versions match, run the setup without updating
if ($localVersion -eq $remoteVersion) {
    Write-Host "No updates found. Running setup..."
    & "$repoFolder\electronjs-setup.ps1"
    exit 0
}

# Move out of the folder before deleting
Write-Host "Update available! Updating..."
$parentFolder = Split-Path $repoFolder -Parent
Set-Location $parentFolder

# Ensure the folder is not in use
Start-Sleep -Seconds 2

# Retry deletion in case of access issues
$retryCount = 3
for ($i = 0; $i -lt $retryCount; $i++) {
    try {
        Remove-Item -Path $repoFolder -Recurse -Force -ErrorAction Stop
        break
    } catch {
        Write-Host "Retrying deletion... ($($i+1)/$retryCount)"
        Start-Sleep -Seconds 2
    }
}

if (Test-Path $repoFolder) {
    Write-Host "Error: Failed to delete existing folder. Exiting..."
    exit 1
}

# Clone the latest version
git clone $repoUrl $repoFolder
Set-Location $repoFolder

# Run the updated setup script
powershell -ExecutionPolicy Bypass -File "$repoFolder\setup.ps1"