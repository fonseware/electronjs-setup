Clear-Host

function functionDrawLogo {
    Clear-Host
    # https://www.asciiart.eu/text-to-ascii-art
    Write-Host @"
      _           _                      _                _               
  ___| | ___  ___| |_ _ __ ___  _ __    (_)___   ___  ___| |_ _   _ _ __  
 / _ \ |/ _ \/ __| __| '__/ _ \| '_ \   | / __| / __|/ _ \ __| | | | '_ \ 
|  __/ |  __/ (__| |_| | | (_) | | | |_ | \__ \ \__ \  __/ |_| |_| | |_) |
 \___|_|\___|\___|\__|_|  \___/|_| |_(_)/ |___/ |___/\___|\__|\__,_| .__/ 
                                      |__/                         |_|    
__________________________________________SCRIPT INSTALLTION SETUP_____________

"@ -ForegroundColor Green
}

function functionDrawLine {
    Write-Host "_______________________________________________________________________________" -ForegroundColor Yellow
}

function functionShowMenu {
    Write-Host @"
Welcome to Electron.JS Setup, a powerful and easy-to-use script designed to 
quickly set up your Electron.js projects. Whether you're a beginner or an 
experienced developer, this script will streamline the process of creating a
 new Electron app from scratch.

* No need to manually configure your project. Just answer a few simple 
prompts, and the script does the rest.

* It automatically checks and installs essential tools such as Chocolatey, 
Visual Studio Code, and Node.js.

* It creates a new Electron project directory, sets up npm, installs Electron,
 and generates the essential files (like main.js and index.html).

* Once your project is set up, the script opens it directly in Visual Studio 
Code, so you can start coding right away.

* From initializing your project to launching the app, the script takes care 
of every step, so you don't have to.

Press [Enter] to check for updates and continue...
"@ -ForegroundColor Cyan
    functionDrawLine
}

# Path to the local version.txt file in the repo
$localVersionFilePath = ".\version.txt"

# URL of the remote version.txt file on GitHub
$remoteVersionUrl = "https://raw.githubusercontent.com/fonseware/electronjs-setup/main/version.txt"

# Function to get the local version from version.txt
function Get-LocalVersion {
    if (Test-Path $localVersionFilePath) {
        return Get-Content $localVersionFilePath | Out-String
    }
    else {
        Clear-Host
        functionDrawLogo
        Write-Host "Local version file not found." -ForegroundColor Red
        return $null
    }
}

# Function to get the remote version from GitHub
function Get-RemoteVersion {
    try {
        $response = Invoke-WebRequest -Uri $remoteVersionUrl -Method Get
        return $response.Content
    }
    catch {
        Clear-Host
        functionDrawLogo
        Write-Host "Failed to fetch the remote version from GitHub." -ForegroundColor Red
        return $null
    }
}

# Compare local and remote versions
function Compare-Versions {
    Clear-Host
    functionDrawLogo
    $localVersion = Get-LocalVersion
    $remoteVersion = Get-RemoteVersion

    if ($localVersion -eq $null -or $remoteVersion -eq $null) {
        Write-Host "Could not compare versions. Ensure both files are accessible." -ForegroundColor Red
        return
    }

    $localVersion = $localVersion.Trim()
    $remoteVersion = $remoteVersion.Trim()

    if ($localVersion -ne $remoteVersion) {
        $currentFolder = $PSScriptRoot
        Write-Host "An update is available! Installed version: $localVersion, New version: $remoteVersion" -ForegroundColor Yellow
        Write-Host @"
`nPlease update the script to the latest version to continue!
`nPlease delete the scripts in this folder (Ctrl + Click to open the folder):
    
    $currentFolder

Run this on Command Prompt again: 
"@ -ForegroundColor Cyan
        Write-Host @"
        
    git clone https://github.com/fonseware/electronjs-setup.git
    cd electronjs-setup
    powershell -ExecutionPolicy Bypass -File setup.ps1
"@ -ForegroundColor Cyan
    }
    else {
        #Write-Host "You are using the latest version: $localVersion." -ForegroundColor Green
        .\electronjs-setup.ps1
    }
    functionDrawLine
    Pause
}

# Run the version comparison
functionDrawLogo
functionShowMenu
Pause
Compare-Versions