# MIT License
# Copyright (c) 2025 fonseware
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

$host.UI.RawUI.WindowTitle = "Electron.js Setup"
$host.UI.RawUI.ForegroundColor = "White"
$currentFolder = $PSScriptRoot
Clear-Host

function functionDrawLogo2 {
  Clear-Host
  # https://www.asciiart.eu/text-to-ascii-art
  Write-Host @"
      _           _                      _                _               
  ___| | ___  ___| |_ _ __ ___  _ __    (_)___   ___  ___| |_ _   _ _ __  
 / _ \ |/ _ \/ __| __| '__/ _ \| '_ \   | / __| / __|/ _ \ __| | | | '_ \ 
|  __/ |  __/ (__| |_| | | (_) | | | |_ | \__ \ \__ \  __/ |_| |_| | |_) |
 \___|_|\___|\___|\__|_|  \___/|_| |_(_)/ |___/ |___/\___|\__|\__,_| .__/ 
                                      |__/                         |_|    
_____________________[  WELCOME TO ELECTRON.JS SETUP  ]________________________`n
"@ -ForegroundColor Green
}

function functionDrawLogo {
  Clear-Host
  # https://www.asciiart.eu/text-to-ascii-art
  Write-Host @"
      _           _                      _                _               
  ___| | ___  ___| |_ _ __ ___  _ __    (_)___   ___  ___| |_ _   _ _ __  
 / _ \ |/ _ \/ __| __| '__/ _ \| '_ \   | / __| / __|/ _ \ __| | | | '_ \ 
|  __/ |  __/ (__| |_| | | (_) | | | |_ | \__ \ \__ \  __/ |_| |_| | |_) |
 \___|_|\___|\___|\__|_|  \___/|_| |_(_)/ |___/ |___/\___|\__|\__,_| .__/ 
                                      |__/                         |_|   v$localVersion
_______________________________________________________________________________`n
"@ -ForegroundColor Green
}

function functionDrawLine {
  Write-Host "_______________________________________________________________________________" -ForegroundColor Yellow
}

function Test-InternetConnection {
  try {
    $url = "https://www.google.com"
    $response = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -TimeoutSec 5
    return $true
  }
  catch {
    return $false
  }
}

function functionShowInfoScreen {
  Write-Host @"
This PowerShell script is designed to simplify the process of setting up and 
creating new Electron.js projects. Whether you're a beginner or an experienced 
developer, this script automates the installation of essential tools, 
initializes your project, and generates the necessary files to get you started 
quickly. It also provides options to create different types of Electron apps, 
including a basic Electron app, a Vite-based app, and a Windows-style app.`n
 - The script checks for and installs essential tools like Chocolatey, Node.js, 
   and Visual Studio Code if they are not already installed on your system.`n
 - Automatically creates a new Electron.js project directory, initializes npm, 
   and installs Electron as a dependency.`n
 - Generates essential files such as main.js, index.html, and package.json 
   with default configurations, saving you time on boilerplate code.`n
 - Multiple Project Templates: Basic Electron App, Vite-based Electron App,
   Windows-style Electron App`n
 - Automatically opens the newly created project in Visual Studio Code, allowing 
   you to start coding immediately.`n
 - Provides error logging and user-friendly prompts to guide you through the 
   setup process, even if something goes wrong.
"@ -ForegroundColor Cyan
  functionDrawLine
}

# Path to the local version.txt file in the repo
$localVersionFilePath = ".\version.txt"

# URL of the remote version.txt file on GitHub
#$remoteVersionUrl = "https://raw.githubusercontent.com/fonseware/electronjs-setup/test/version.txt"
$remoteVersionUrl = "https://raw.githubusercontent.com/fonseware/electronjs-setup/main/version.txt"


# Function to get the local version from version.txt
function Get-LocalVersion {
  if (Test-Path $localVersionFilePath) {
    return Get-Content $localVersionFilePath | Out-String
  }
  else {
    Clear-Host
    functionDrawLogo2
    Write-Host "Local version file not found." -ForegroundColor Red
    Start-Sleep -Seconds 1
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
    functionDrawLogo2
    Write-Host "Failed to fetch the remote version from GitHub." -ForegroundColor Red
    Start-Sleep -Seconds 1
    return $null
  }
}

# Compare local and remote versions
function Compare-Versions {
  Clear-Host
  functionDrawLogo2
  Write-Host "Checking for updates..." -ForegroundColor Yellow
  start-sleep -Seconds 1
  $localVersion = Get-LocalVersion
  $remoteVersion = Get-RemoteVersion

  if ($null -eq $localVersion -or $null -eq $remoteVersion) {
    Write-Host "Could not compare versions. Ensure both files are accessible." -ForegroundColor Red
    Start-Sleep -Seconds 1
    return
  }

  $localVersion = $localVersion.Trim()
  $remoteVersion = $remoteVersion.Trim()

  if ($localVersion -ne $remoteVersion) {
    $currentFolder = $PSScriptRoot
    functionDrawLogo2
    Write-Host "A new version $remoteVersion is available, your currently installed version is $localVersion" -ForegroundColor Yellow
    Write-Host @"
`nPlease update the script to the latest version!
You still can use this script without updating, but it is recommended to `nupdate to the latest version for the best experience.
`nPlease delete the files in this folder:`n
"@ -ForegroundColor Yellow
    Write-Host "    $currentFolder`n" -ForegroundColor Cyan
    Write-Host "THEN run this command on Command Prompt:" -ForegroundColor Yellow
    Write-Host @"

    git clone https://github.com/fonseware/electronjs-setup.git
    cd electronjs-setup
    powershell -ExecutionPolicy Bypass -File setup.ps1
"@ -ForegroundColor Cyan
    functionDrawLine
    Pause
    Clear-Host
  }
  else {
    functionDrawLogo2
    Write-Host "You are using the latest version." -ForegroundColor Green
    Start-Sleep -Seconds 1
  }
}

function functionCheckForPrerequisites {
  functionDrawLogo
  # Check internet connection before proceeding
  Write-Host "Checking for network connection..." -ForegroundColor Yellow
  start-sleep -Seconds 1
  if (-not (Test-InternetConnection)) {
    Write-Host "No internet connection. Please connect to the internet and try again." -ForegroundColor Red
    return
  }
  functionDrawLogo
  Write-Host @"
This script will check for and install the following prerequisites: 
- Chocolatey
- Node.js
- Visual Studio Code

By continuing, you agree to install these prerequisites on your system.
 - Chocolatey: https://docs.chocolatey.org/en-us/information/legal/
 - Visual Studio Code: https://code.visualstudio.com/license
 - Node.js: https://github.com/nodejs/node/blob/main/LICENSE
"@ -ForegroundColor Yellow
  functionDrawLine
  Write-Host "`nPress [Enter] to accept and continue or type '1' to go to main menu."
  $inputValue = Read-Host "Enter your choice"
  if ($inputValue -eq "1") {
    return
  } 
  if ($inputValue -eq "") {} else {
    Write-Host "`nInvalid input..." -ForegroundColor Red
    return
  }
  functionDrawLogo
  Write-Host "Checking for prerequisites..." -ForegroundColor Yellow
  Write-Host "[-] Chocolatey"-ForegroundColor Yellow
  Write-Host "[ ] Node.js"-ForegroundColor DarkGray
  Write-Host "[ ] Visual Studio Code"-ForegroundColor DarkGray
  if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "`nChocolatey is not installed. Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Start-Sleep -Seconds 5
  }
  else {
    Write-Host "`nChocolatey is already installed." -ForegroundColor Green
  }
  Start-Sleep -Seconds 1

  functionDrawLogo
  Write-Host "Checking for prerequisites..." -ForegroundColor Yellow
  Write-Host "[*] Chocolatey"-ForegroundColor Green
  Write-Host "[-] Node.js"-ForegroundColor Yellow
  Write-Host "[ ] Visual Studio Code"-ForegroundColor DarkGray
  ##
  function Install-NvmIfNeeded {
    if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
      Write-Host "NVM is not installed. Installing via Chocolatey..." -ForegroundColor Yellow
      choco install nvm -y
      # Refresh environment variables
      $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    }
  }

  function Install-NodeJsWithOptions {
    param([bool]$nodeAlreadyInstalled)

    # Prompt if Node.js is already installed
    if ($nodeAlreadyInstalled) {
      Write-Host "`nNode.js is already installed." -ForegroundColor Green
      $installAnother = Read-Host "Do you want to install another version of node.js? (Y/N)"
      if ($installAnother -notmatch '^[Yy]') { return }
    }

    # Installation options menu
    functionDrawLine
    Write-Host "Choose Node.js installation method:`n" -ForegroundColor Yellow
    Write-Host "1. Install latest version via Chocolatey" -ForegroundColor Cyan
    Write-Host "2. Install latest version using NVM" -ForegroundColor Cyan
    Write-Host "3. Choose specific version with NVM" -ForegroundColor Cyan
    Write-Host "4. Skip Node.js installation" -ForegroundColor Cyan
    $choice = Read-Host "Enter your choice (1-4)"

    switch ($choice) {
      '1' {
        Write-Host "`nInstalling Node.js via Chocolatey..." -ForegroundColor Yellow
        choco install nodejs -y
      }
      '2' {
        Install-NvmIfNeeded
        Write-Host "`nInstalling latest Node.js via NVM..." -ForegroundColor Yellow
        nvm install latest
        nvm use latest
      }
      '3' {
        Install-NvmIfNeeded
        $version = Read-Host "`nEnter the Node.js version (e.g., 20.13.1)"
        Write-Host "`,Installing Node.js $version via NVM..." -ForegroundColor Yellow
        nvm install $version
        nvm use $version
      }
      '4' { 
        Write-Host "`nSkipping installation." -ForegroundColor Yellow 
        return 
      }
      default { 
        Write-Host "`nInvalid choice. Skipping." -ForegroundColor Red 
        return 
      }
    }

    # Verify installation
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
      Write-Host "`nNode.js installation failed!" -ForegroundColor Red
    }
  }

  # Check if Node.js is already installed
  $nodeInstalled = [bool](Get-Command node -ErrorAction SilentlyContinue)
  
  # Run installation menu
  Install-NodeJsWithOptions -nodeAlreadyInstalled $nodeInstalled

  # Final check
  if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "`nNode.js is still missing. Some features may not work." -ForegroundColor Red
    Start-Sleep -Seconds 2
  }
  ##
  Start-Sleep -Seconds 1
  functionDrawLogo
  Write-Host "Checking for prerequisites..." -ForegroundColor Yellow
  Write-Host "[*] Chocolatey"-ForegroundColor Green
  Write-Host "[*] Node.js"-ForegroundColor Green
  Write-Host "[-] Visual Studio Code"-ForegroundColor Yellow

  $vsCodePath = Get-Command 'code' -ErrorAction SilentlyContinue
  if (-not $vsCodePath) {
    Write-Host "`nVisual Studio Code is not installed. Installing VS Code..." -ForegroundColor Yellow
    choco install vscode -y
  }
  else {
    Write-Host "`nVisual Studio Code is already installed." -ForegroundColor Green
  }

  Start-Sleep -Seconds 1
  functionDrawLogo
  Write-Host "Checking for prerequisites..." -ForegroundColor Yellow
  Write-Host "[*] Chocolatey"-ForegroundColor Green
  Write-Host "[*] Node.js"-ForegroundColor Green
  Write-Host "[*] Visual Studio Code"-ForegroundColor Green
  Write-Host "`nAll prerequisites are installed." -ForegroundColor Green
}

function functionCreateElectronAppDefault {
  functionDrawLogo
  # Check internet connection before proceeding
  Write-Host "Checking for network connection..." -ForegroundColor Yellow
  start-sleep -Seconds 1
  if (-not (Test-InternetConnection)) {
    Write-Host "No internet connection. Please connect to the internet and try again." -ForegroundColor Red
    return
  }
  functionDrawLogo
  Write-Host "Creating a new Electron.js app..." -ForegroundColor Yellow
  Write-Host "[-] Step 1: Name of the project"-ForegroundColor Yellow
  Write-Host "[ ] Step 2: Creating project directory and initialise npm"-ForegroundColor DarkGray
  Write-Host "[ ] Step 3: Installing Electron to project"-ForegroundColor DarkGray
  Write-Host "[ ] Step 4: Creating main.js file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 5: Creating index.html file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 6: Updating package.json file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 8: Building Electron app"-ForegroundColor DarkGray
  functionDrawLine
  do {
    $projectName = Read-Host "Enter the name of your Electron project (use dashes instead of spaces)"
    if (-not [string]::IsNullOrWhiteSpace($projectName)) {
      $projectName = $projectName -replace ' ', '-'
    }
    else {
      Write-Host "Error: Project name cannot be empty. Please try again." -ForegroundColor Red
      return
    }
  } while ([string]::IsNullOrWhiteSpace($projectName))
  do {
    $defaultLocation = "C:\Users\$env:USERNAME\source\repos"
    $projectLocation = Read-Host "Enter the location (press [Enter] to use default: $defaultLocation\)"
    if ([string]::IsNullOrWhiteSpace($projectLocation)) {
      $projectLocation = $defaultLocation
      Write-Host "No input provided. The project will be saved in: $projectLocation\" -ForegroundColor Yellow
    }
    if (Test-Path "$projectLocation\$projectName") {
      Write-Host "Error: A folder already exists at this location. Please enter a different path." -ForegroundColor Red
    }
    else {
      break
    }
  } while ($true)
  functionDrawLine
  Write-Host "Review your project settings..." -ForegroundColor Yellow
  Write-Host "Project Name: $projectName"
  Write-Host "Save Location: $projectLocation\"
  Write-Host "Project Location: $projectLocation\$projectName\" -ForegroundColor Yellow
  functionDrawLine
  Write-Host "`nPress [Enter] to continue or type '1' to go to main menu, to start over..."
  $inputValue = Read-Host "Enter your choice"
  if ($inputValue -eq "1") {
    return
  } 
  if ($inputValue -eq "") {} else {
    Write-Host "`nInvalid input..." -ForegroundColor Red
    return
  }
  functionDrawLogo
  Write-Host "Creating a new Electron.js app..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[-] Step 2: Creating project directory and initialise npm"-ForegroundColor Yellow
  Write-Host "[ ] Step 3: Installing Electron to project"-ForegroundColor DarkGray
  Write-Host "[ ] Step 4: Creating main.js file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 5: Creating index.html file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 6: Updating package.json file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 8: Building Electron app"-ForegroundColor DarkGray
  $fullPath = Join-Path -Path $projectLocation -ChildPath $projectName
  mkdir $fullPath | Out-Null
  Set-Location -Path $fullPath
  npm init -y > $null 2>&1
  Start-Sleep -Seconds 2
  functionDrawLogo
  Write-Host "Creating a new Electron.js app..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[-] Step 3: Installing Electron to project"-ForegroundColor Yellow
  Write-Host "[ ] Step 4: Creating main.js file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 5: Creating index.html file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 6: Updating package.json file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 8: Building Electron app"-ForegroundColor DarkGray
  functionDrawLine
  Write-Host "This process may take some time, please wait...`n"
  Write-Host "`nFor errors in this process, check the project logs for more info." -ForegroundColor Yellow
  Write-host "Located: $projectLocation\$projectName\error.log" -ForegroundColor Yellow
  npm install --save-dev electron > $null 2> error.log
  Start-Sleep -Seconds 2
  functionDrawLogo
  Write-Host "Creating a new Electron.js app..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[-] Step 4: Creating main.js file"-ForegroundColor Yellow
  Write-Host "[ ] Step 5: Creating index.html file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 6: Updating package.json file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 8: Building Electron app"-ForegroundColor DarkGray
  $mainJsContent = @"
const { app, BrowserWindow } = require('electron');

function createWindow() {
    const win = new BrowserWindow({
        width: 800,
        height: 600,
        webPreferences: {
            nodeIntegration: true,
        },
    });

    win.loadFile('index.html');
}

app.whenReady().then(() => {
    createWindow();

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) createWindow();
    });
});

app.on('window-all-closed', () => {`
    if (process.platform !== 'darwin') app.quit();
});
"@
  Set-Content -Path (Join-Path -Path $fullPath -ChildPath "main.js") -Value $mainJsContent
  Start-Sleep -Seconds 1
  functionDrawLogo
  Write-Host "Creating a new Electron.js app..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[*] Step 4: Creating main.js file"-ForegroundColor Green
  Write-Host "[-] Step 5: Creating index.html file"-ForegroundColor Yellow
  Write-Host "[ ] Step 6: Updating package.json file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 8: Building Electron app"-ForegroundColor DarkGray
  $htmlContent = @"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Electron Starter App</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        text-align: center;
        padding: 40px;
        background-color: #f0f0f0;
      }
      .container {
        max-width: 800px;
        margin: 0 auto;
      }
      h1 {
        color: #2e3c4d;
        font-size: 2.5em;
        margin-bottom: 20px;
      }
      h2 {
        color: #3a506b;
        margin-bottom: 30px;
      }
      p {
        color: #555;
        line-height: 1.6;
        margin: 15px 0;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>🚀 Welcome to Electron!</h1>
      <h2>You've successfully set up your Electron application</h2>

      <p>
        Start building your application by modifying the
        <code>index.html</code> file and adding your custom functionality.
      </p>
      <p>
        This basic template includes everything you need to begin developing
        your cross-platform desktop app.
      </p>
      <p>
        Check out the Electron documentation to explore all the powerful
        features available!
      </p>
    </div>
  </body>
</html>
"@
  Set-Content -Path (Join-Path -Path $fullPath -ChildPath "index.html") -Value $htmlContent
  Start-Sleep -Seconds 1
  functionDrawLogo
  Write-Host "Creating a new Electron.js app..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[*] Step 4: Creating main.js file"-ForegroundColor Green
  Write-Host "[*] Step 5: Creating index.html file"-ForegroundColor Green
  Write-Host "[-] Step 6: Updating package.json file"-ForegroundColor Yellow
  Write-Host "[ ] Step 7: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 8: Building Electron app"-ForegroundColor DarkGray
  $jsonPath = Join-Path -Path $fullPath -ChildPath "package.json"
  $jsonContent = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json
  $jsonContent.main = "main.js"
  $jsonContent.scripts = @{ "start" = "electron ." }
  $jsonContent | ConvertTo-Json -Compress | Set-Content -Path $jsonPath
  Start-Sleep -Seconds 1
  functionDrawLogo
  Write-Host "Creating a new Electron.js app..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[*] Step 4: Creating main.js file"-ForegroundColor Green
  Write-Host "[*] Step 5: Creating index.html file"-ForegroundColor Green
  Write-Host "[*] Step 6: Updating package.json file"-ForegroundColor Green
  Write-Host "[-] Step 7: Opening project in Visual Studio Code"-ForegroundColor Yellow
  Write-Host "[ ] Step 8: Building Electron app"-ForegroundColor DarkGray
  Set-Location -Path $fullPath
  code .
  Start-Sleep -Seconds 2
  functionDrawLogo
  Write-Host "Creating a new Electron.js app..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[*] Step 4: Creating main.js file"-ForegroundColor Green
  Write-Host "[*] Step 5: Creating index.html file"-ForegroundColor Green
  Write-Host "[*] Step 6: Updating package.json file"-ForegroundColor Green
  Write-Host "[*] Step 7: Opening project in Visual Studio Code"-ForegroundColor Green
  Write-Host "[-] Step 8: Building Electron app"-ForegroundColor Yellow
  functionDrawLine
  Write-Host "| To run your Electron app, open a new terminal in VS Code and run the following command:" -ForegroundColor Yellow
  Write-Host "| npm start" -ForegroundColor Cyan
  #Write-Host "`n`tnpm start`n" -ForegroundColor Cyan
  npm start > $null 2>&1
  Start-Sleep -Seconds 2
  functionDrawLogo
  Write-Host "Creating a new Electron.js app..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[*] Step 4: Creating main.js file"-ForegroundColor Green
  Write-Host "[*] Step 5: Creating index.html file"-ForegroundColor Green
  Write-Host "[*] Step 6: Updating package.json file"-ForegroundColor Green
  Write-Host "[*] Step 7: Opening project in Visual Studio Code"-ForegroundColor Green
  Write-Host "[*] Step 8: Building Electron app"-ForegroundColor Green
  write-host "`nYour Electron app has been created successfully!" -ForegroundColor Green
  write-host "`nThank you for using the Electron.js Setup script." -ForegroundColor Green
}

function functionCreateElectronAppVite {
  functionDrawLogo
  Write-Host "You are about to run a script, outside the scope of this setup.`n" -ForegroundColor Yellow
  Write-Host "    npm create @quick-start/electron@latest`n" -ForegroundColor Cyan
  Write-Host "If you want to exit while running the above script, press [Escape]." -ForegroundColor Yellow
  functionDrawLine
  Write-Host "Press [Enter] to start the script or type '1' to go to main menu."
  $inputValue = Read-Host "Enter your choice"
  if ($inputValue -eq "1") {
    return
  } 
  if ($inputValue -eq "") {} else {
    Write-Host "`nInvalid input..." -ForegroundColor Red
    return
  }
  Clear-Host
  functionDrawLogo
  Write-Host "running command ""npm create @quick-start/electron@latest""" -ForegroundColor Cyan
  functionDrawLine
  npm create @quick-start/electron@latest
}

function functionCreateElectronAppWindowsStyle {
  functionDrawLogo
  # Check internet connection before proceeding
  Write-Host "Checking for network connection..." -ForegroundColor Yellow
  start-sleep -Seconds 1
  if (-not (Test-InternetConnection)) {
    Write-Host "No internet connection. Please connect to the internet and try again." -ForegroundColor Red
    return
  }
  functionDrawLogo
  Write-Host "Creating a new Electron.js app with Windows Style..." -ForegroundColor Yellow
  Write-Host "[-] Step 1: Name of the project"-ForegroundColor Yellow
  Write-Host "[ ] Step 2: Creating project directory and initialise npm"-ForegroundColor DarkGray
  Write-Host "[ ] Step 3: Installing Electron to project"-ForegroundColor DarkGray
  Write-Host "[ ] Step 4: Creating all files"-ForegroundColor DarkGray
  Write-Host "[ ] Step 5: Updating package.json file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 6: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Building Electron app"-ForegroundColor DarkGray
  functionDrawLine
  do {
    $projectName = Read-Host "Enter the name of your Electron project (use dashes instead of spaces)"
    if (-not [string]::IsNullOrWhiteSpace($projectName)) {
      $projectName = $projectName -replace ' ', '-'
    }
    else {
      Write-Host "Error: Project name cannot be empty. Please try again." -ForegroundColor Red
      return
    }
  } while ([string]::IsNullOrWhiteSpace($projectName))
  do {
    $defaultLocation = "C:\Users\$env:USERNAME\source\repos"
    $projectLocation = Read-Host "Enter the location (press [Enter] to use default: $defaultLocation\)"
    if ([string]::IsNullOrWhiteSpace($projectLocation)) {
      $projectLocation = $defaultLocation
      Write-Host "No input provided. The project will be saved in: $projectLocation\" -ForegroundColor Yellow
    }
    if (Test-Path "$projectLocation\$projectName") {
      Write-Host "Error: A folder already exists at this location. Please enter a different path." -ForegroundColor Red
    }
    else {
      break
    }
  } while ($true)
  functionDrawLine
  Write-Host "Review your project settings..." -ForegroundColor Yellow
  Write-Host "Project Name: $projectName"
  Write-Host "Save Location: $projectLocation\"
  Write-Host "Project Location: $projectLocation\$projectName\" -ForegroundColor Yellow
  functionDrawLine
  Write-Host "`nPress [Enter] to continue or type '1' to go to main menu, to start over..."
  $inputValue = Read-Host "Enter your choice"
  if ($inputValue -eq "1") {
    return
  } 
  if ($inputValue -eq "") {} else {
    Write-Host "`nInvalid input..." -ForegroundColor Red
    return
  }
  functionDrawLogo
  Write-Host "Creating a new Electron.js app with Windows Style..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[-] Step 2: Creating project directory and initialise npm"-ForegroundColor Yellow
  Write-Host "[ ] Step 3: Installing Electron to project"-ForegroundColor DarkGray
  Write-Host "[ ] Step 4: Creating all files"-ForegroundColor DarkGray
  Write-Host "[ ] Step 5: Updating package.json file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 6: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Building Electron app"-ForegroundColor DarkGray
  $fullPath = Join-Path -Path $projectLocation -ChildPath $projectName
  mkdir $fullPath | Out-Null
  Set-Location -Path $fullPath
  npm init -y > $null 2>&1
  Start-Sleep -Seconds 2
  functionDrawLogo
  Write-Host "Creating a new Electron.js app with Windows Style..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[-] Step 3: Installing Electron to project"-ForegroundColor Yellow
  Write-Host "[ ] Step 4: Creating all files"-ForegroundColor DarkGray
  Write-Host "[ ] Step 5: Updating package.json file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 6: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Building Electron app"-ForegroundColor DarkGray
  functionDrawLine
  Write-Host "This process may take some time, please wait...`n"
  Write-Host "`nFor errors in this process, check the project logs for more info." -ForegroundColor Yellow
  Write-host "Located: $projectLocation\$projectName\error.log" -ForegroundColor Yellow
  npm install --save-dev electron > $null 2> error.log
  Start-Sleep -Seconds 2
  functionDrawLogo
  Write-Host "Creating a new Electron.js app with Windows Style..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[-] Step 4: Creating all files"-ForegroundColor Yellow
  Write-Host "[ ] Step 5: Updating package.json file"-ForegroundColor DarkGray
  Write-Host "[ ] Step 6: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Building Electron app"-ForegroundColor DarkGray
  functionDrawLine
  Write-Host "This process may take some time, please wait...`n"
  $mainJsContent = @"
const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');

let mainWindow;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    frame: false,
    backgroundColor: '#FFF',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
    },
  });

  mainWindow.loadFile('index.html');

  // Open DevTools (optional)
  // mainWindow.webContents.openDevTools();
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

// IPC handlers for window controls
ipcMain.on('minimize-window', () => {
  mainWindow.minimize();
});

ipcMain.on('maximize-window', () => {
  if (mainWindow.isMaximized()) {
    mainWindow.unmaximize();
  } else {
    mainWindow.maximize();
  }
});

ipcMain.on('close-window', () => {
  mainWindow.close();
});
"@
  Set-Content -Path (Join-Path -Path $fullPath -ChildPath "main.js") -Value $mainJsContent
  Start-Sleep -Seconds 1
  $htmlContent = @"
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Electron Modern Home</title>
    <link rel="stylesheet" href="style.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>
  <body>
    <header id="titlebar">
      <div id="drag-region">
        <div id="window-title">
          <span>Electron Modern Home</span>
        </div>

        <div id="window-controls">
          <div class="button" id="min-button">
            <img
              class="icon"
              srcset="
                icons/min-w-10.png 1x,
                icons/min-w-12.png 1.25x,
                icons/min-w-15.png 1.5x,
                icons/min-w-15.png 1.75x,
                icons/min-w-20.png 2x,
                icons/min-w-20.png 2.25x,
                icons/min-w-24.png 2.5x,
                icons/min-w-30.png 3x,
                icons/min-w-30.png 3.5x
              "
              draggable="false"
            />
          </div>
          <div class="button" id="max-button">
            <img
              class="icon"
              srcset="
                icons/max-w-10.png 1x,
                icons/max-w-12.png 1.25x,
                icons/max-w-15.png 1.5x,
                icons/max-w-15.png 1.75x,
                icons/max-w-20.png 2x,
                icons/max-w-20.png 2.25x,
                icons/max-w-24.png 2.5x,
                icons/max-w-30.png 3x,
                icons/max-w-30.png 3.5x
              "
              draggable="false"
            />
          </div>
          <div class="button" id="restore-button">
            <img
              class="icon"
              srcset="
                icons/restore-w-10.png 1x,
                icons/restore-w-12.png 1.25x,
                icons/restore-w-15.png 1.5x,
                icons/restore-w-15.png 1.75x,
                icons/restore-w-20.png 2x,
                icons/restore-w-20.png 2.25x,
                icons/restore-w-24.png 2.5x,
                icons/restore-w-30.png 3x,
                icons/restore-w-30.png 3.5x
              "
              draggable="false"
            />
          </div>
          <div class="button" id="close-button">
            <img
              class="icon"
              srcset="
                icons/close-w-10.png 1x,
                icons/close-w-12.png 1.25x,
                icons/close-w-15.png 1.5x,
                icons/close-w-15.png 1.75x,
                icons/close-w-20.png 2x,
                icons/close-w-20.png 2.25x,
                icons/close-w-24.png 2.5x,
                icons/close-w-30.png 3x,
                icons/close-w-30.png 3.5x
              "
              draggable="false"
            />
          </div>
        </div>
      </div>
    </header>

    <div id="main">
      <section class="hero">
        <div class="hero-content">
          <h1 class="gradient-text">Welcome to Electron.js</h1>
          <p class="hero-subtitle">
            Build cross-platform apps with elegance and speed. 
            This demo project is made using the Electron.js script. Tell a friend about this script.
          </p>
          <a
            href="https://www.electronjs.org/docs/latest/tutorial/tutorial-first-app"
          >
            <button class="cta-button">
              Get Started <i class="fas fa-arrow-right"></i>
            </button>
          </a>
        </div>
      </section>

      <section class="features">
        <div class="feature-card">
          <i class="fas fa-bolt feature-icon"></i>
          <h3>Lightning Fast</h3>
          <p>
            Harness the power of Electron's optimized architecture for seamless
            performance.
          </p>
        </div>
        <div class="feature-card">
          <i class="fas fa-paint-brush feature-icon"></i>
          <h3>Beautiful UI</h3>
          <p>
            Create stunning interfaces with our modern design system and CSS
            framework.
          </p>
        </div>
        <div class="feature-card">
          <i class="fas fa-code feature-icon"></i>
          <h3>Easy Development</h3>
          <p>
            Full TypeScript support and intuitive API for rapid application
            development.
          </p>
        </div>
      </section>

      <section class="info-section">
        <h2>Start Your Journey</h2>
        <div class="info-grid">
          <div class="info-card">
            <div class="card-header">
              <i class="fas fa-book-open"></i>
              <h4>Documentation</h4>
            </div>
            <p>Explore our comprehensive guides and API references.</p>
            <a href="https://www.electronjs.org/docs/latest" class="card-link"
              >Read More <i class="fas fa-external-link-alt"></i
            ></a>
          </div>
          <div class="info-card">
            <div class="card-header">
              <i class="fas fa-download"></i>
              <h4>Installation</h4>
            </div>
            <p>Get started with our simple setup process and CLI tools.</p>
            <a
              href="https://github.com/electron/electron/releases"
              class="card-link"
              >Download Now <i class="fas fa-download"></i
            ></a>
          </div>
        </div>
      </section>
    </div>

    <script src="renderer.js"></script>
  </body>
</html>
"@
  Set-Content -Path (Join-Path -Path $fullPath -ChildPath "index.html") -Value $htmlContent
  Start-Sleep -Seconds 1
  $cssContent = @"
/* Basic styling */
* {
  margin: 0;
  padding: 0;
  border: 0;
  vertical-align: baseline;
}
html {
  box-sizing: border-box;
}
*,
*:before,
*:after {
  box-sizing: inherit;
}
html,
body {
  height: 100%;
  margin: 0;
}

body {
  font-family: "Segoe UI", sans-serif;
  background: #1a2933;
  color: #fff;
}

h1 {
  margin: 0 0 10px 0;
  font-weight: 600;
  line-height: 1.2;
}

p {
  margin-top: 10px;
  color: rgba(255, 255, 255, 0.4);
}

/* Styling of window frame and titlebar */
body {
  border: 1px solid #48545c;
  overflow-y: hidden;
}

#titlebar {
  display: block;
  position: fixed;
  height: 32px;
  width: calc(100% - 2px);
}

.maximized #titlebar {
  width: 100%;
  padding: 0;
}

#main {
  height: calc(100% - 32px);
  margin-top: 32px;
  padding: 20px;
  overflow-y: auto;
}

#titlebar {
  padding: 4px;
}

#titlebar #drag-region {
  width: 100%;
  height: 100%;
  -webkit-app-region: drag;
}

#titlebar {
  color: #fff;
}

#titlebar #drag-region {
  display: grid;
  grid-template-columns: auto 138px;
}

#window-title {
  grid-column: 1;
  display: flex;
  align-items: center;
  margin-left: 8px;
  overflow: hidden;
  font-family: "Segoe UI", sans-serif;
  font-size: 12px;
}

.maximized #window-title {
  margin-left: 12px;
}

#window-title span {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  line-height: 1.5;
}

#window-controls {
  display: grid;
  grid-template-columns: repeat(3, 46px);
  position: absolute;
  top: 0;
  right: 0;
  height: 100%;
}

#window-controls {
  -webkit-app-region: no-drag;
}

#window-controls .button {
  grid-row: 1 / span 1;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}

@media (-webkit-device-pixel-ratio: 1.5),
  (device-pixel-ratio: 1.5),
  (-webkit-device-pixel-ratio: 2),
  (device-pixel-ratio: 2),
  (-webkit-device-pixel-ratio: 3),
  (device-pixel-ratio: 3) {
  #window-controls .icon {
    width: 10px;
    height: 10px;
  }
}

#window-controls .button {
  user-select: none;
}

#window-controls .button:hover {
  background: rgba(255, 255, 255, 0.1);
}

#window-controls .button:active {
  background: rgba(255, 255, 255, 0.2);
}

#close-button:hover {
  background: #e81123 !important;
}

#close-button:active {
  background: #f1707a !important;
}
#close-button:active .icon {
  filter: invert(1);
}

#min-button {
  grid-column: 1;
}
#max-button,
#restore-button {
  grid-column: 2;
}
#close-button {
  grid-column: 3;
}

#restore-button {
  display: none !important;
}

.maximized #restore-button {
  display: flex !important;
}

.maximized #max-button {
  display: none;
}

#main {
  background: linear-gradient(45deg, #0f2027, #203a43, #2c5364);
}

.hero {
  padding: 4rem 2rem;
  text-align: center;
  background: rgba(0, 0, 0, 0.2);
  border-radius: 1rem;
  margin: 2rem 0;
  animation: fadeIn 1s ease-out;
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
}

.gradient-text {
  background: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  font-size: 2.5rem;
  margin-bottom: 1.5rem;
}

.hero-subtitle {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1.2rem;
  margin-bottom: 2rem;
}

.features {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  padding: 2rem 0;
}

.feature-card {
  background: rgba(255, 255, 255, 0.05);
  padding: 2rem;
  border-radius: 15px;
  transition: transform 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.feature-card:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.08);
}

.feature-icon {
  font-size: 2rem;
  color: #4facfe;
  margin-bottom: 1rem;
}

.cta-button {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: white;
  padding: 1rem 2.5rem;
  border-radius: 50px;
  font-size: 1.1rem;
  cursor: pointer;
  transition: transform 0.3s ease;
  border: none;
  display: inline-flex;
  align-items: center;
  gap: 0.8rem;
}

.cta-button:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
}

.info-section {
  margin-top: 4rem;
  padding: 2rem;
  background: rgba(0, 0, 0, 0.15);
  border-radius: 1rem;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-top: 2rem;
}

.info-card {
  background: rgba(255, 255, 255, 0.03);
  padding: 1.5rem;
  border-radius: 10px;
  border-left: 4px solid #4facfe;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
}

.card-link {
  color: #4facfe;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 1rem;
}

.card-link:hover {
  color: #00f2fe;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .features,
  .info-grid {
    grid-template-columns: 1fr;
  }

  .hero {
    padding: 2rem 1rem;
  }
}
"@
  Set-Content -Path (Join-Path -Path $fullPath -ChildPath "style.css") -Value $cssContent
  Start-Sleep -Seconds 1
  $preloadContent = @"
const { contextBridge, ipcRenderer } = require('electron');

// Expose IPC methods to the renderer process
contextBridge.exposeInMainWorld('electronAPI', {
  send: (channel, data) => {
    const validChannels = ['minimize-window', 'maximize-window', 'close-window'];
    if (validChannels.includes(channel)) {
      ipcRenderer.send(channel, data);
    }
  },
  on: (channel, callback) => {
    const validChannels = ['maximize', 'unmaximize'];
    if (validChannels.includes(channel)) {
      ipcRenderer.on(channel, (event, ...args) => callback(...args));
    }
  },
});
"@
  Set-Content -Path (Join-Path -Path $fullPath -ChildPath "preload.js") -Value $preloadContent
  Start-Sleep -Seconds 1
  $rendererContent = @"
document.onreadystatechange = () => {
    if (document.readyState === 'complete') {
      handleWindowControls();
      document.getElementById('electron-ver').textContent = process.versions.electron;
    }
  };
  
  function handleWindowControls() {
    const minButton = document.getElementById('min-button');
    const maxButton = document.getElementById('max-button');
    const restoreButton = document.getElementById('restore-button');
    const closeButton = document.getElementById('close-button');
  
    minButton.addEventListener('click', () => {
      window.electronAPI.send('minimize-window');
    });
  
    maxButton.addEventListener('click', () => {
      window.electronAPI.send('maximize-window');
    });
  
    restoreButton.addEventListener('click', () => {
      window.electronAPI.send('maximize-window');
    });
  
    closeButton.addEventListener('click', () => {
      window.electronAPI.send('close-window');
    });
  
    // Toggle maximize/restore buttons
    window.electronAPI.on('maximize', () => {
      document.body.classList.add('maximized');
    });
  
    window.electronAPI.on('unmaximize', () => {
      document.body.classList.remove('maximized');
    });
  }
"@
  Set-Content -Path (Join-Path -Path $fullPath -ChildPath "renderer.js") -Value $rendererContent
  Start-Sleep -Seconds 1

  # Define the source folder (assuming it's named "icons" and is in the current directory)
  $sourceFolder = Join-Path -Path $PSScriptRoot -ChildPath "icons"

  # Check if the source folder exists
  if (Test-Path -Path $sourceFolder -PathType Container) {
    # Create the destination directory if it doesn't exist
    if (-not (Test-Path -Path $fullPath)) {
      New-Item -ItemType Directory -Path $fullPath | Out-Null
    }

    # Copy the folder to the destination
    Copy-Item -Path $sourceFolder -Destination $fullPath -Recurse -Force

    #Write-Host "Folder 'icons' copied successfully to $fullPath."
  }
  else {
    #Write-Host "Source folder 'icons' does not exist in the current directory."
  }
  Start-Sleep -Seconds 1
  functionDrawLogo
  Write-Host "Creating a new Electron.js app with Windows Style..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[*] Step 4: Creating all files"-ForegroundColor Green
  Write-Host "[-] Step 5: Updating package.json file"-ForegroundColor Yellow
  Write-Host "[ ] Step 6: Opening project in Visual Studio Code"-ForegroundColor DarkGray
  Write-Host "[ ] Step 7: Building Electron app"-ForegroundColor DarkGray
  $jsonPath = Join-Path -Path $fullPath -ChildPath "package.json"
  $jsonContent = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json
  $jsonContent.main = "main.js"
  $jsonContent.scripts = @{ "start" = "electron ." }
  $jsonContent | ConvertTo-Json -Compress | Set-Content -Path $jsonPath
  Start-Sleep -Seconds 1
  functionDrawLogo
  Write-Host "Creating a new Electron.js app with Windows Style..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[*] Step 4: Creating all files"-ForegroundColor Green
  Write-Host "[*] Step 5: Updating package.json file"-ForegroundColor Green
  Write-Host "[-] Step 6: Opening project in Visual Studio Code"-ForegroundColor Yellow
  Write-Host "[ ] Step 7: Building Electron app"-ForegroundColor DarkGray
  Set-Location -Path $fullPath
  code .
  Start-Sleep -Seconds 2
  functionDrawLogo
  Write-Host "Creating a new Electron.js app with Windows Style..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[*] Step 4: Creating all files"-ForegroundColor Green
  Write-Host "[*] Step 5: Updating package.json file"-ForegroundColor Green
  Write-Host "[*] Step 6: Opening project in Visual Studio Code"-ForegroundColor Green
  Write-Host "[-] Step 7: Building Electron app"-ForegroundColor Yellow
  functionDrawLine
  Write-Host "| To run your Electron app, open a new terminal in VS Code and run the following command:" -ForegroundColor Yellow
  Write-Host "| npm start" -ForegroundColor Cyan
  #Write-Host "`n`tnpm start`n" -ForegroundColor Cyan
  npm start > $null 2>&1
  Start-Sleep -Seconds 2
  functionDrawLogo
  Write-Host "Creating a new Electron.js app with Windows Style..." -ForegroundColor Yellow
  Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
  Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
  Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
  Write-Host "[*] Step 4: Creating all files"-ForegroundColor Green
  Write-Host "[*] Step 5: Updating package.json file"-ForegroundColor Green
  Write-Host "[*] Step 6: Opening project in Visual Studio Code"-ForegroundColor Green
  Write-Host "[*] Step 7: Building Electron app"-ForegroundColor Green
  write-host "`nYour Electron app has been created successfully!" -ForegroundColor Green
  write-host "`nThank you for using the Electron.js Setup script." -ForegroundColor Green
}

function functionAboutScript {
  functionDrawLogo
  Write-Host " - About this script`nScript version: $localVersion`n" -ForegroundColor Cyan
  Write-Host " - This script is designed to help you create a new Electron.js app quickly and easily." -ForegroundColor Yellow
  Write-Host " - It will guide you through the process of setting up a new Electron.js project." -ForegroundColor Yellow
  Write-Host " - You can choose to create a basic Electron.js app, an Electron.js app using`nVite templates, or a Windows 10 style Electron.js app." -ForegroundColor Yellow
  Write-Host " - This script will also check for the necessary prerequisites and install them if needed." -ForegroundColor Yellow
  Write-Host @"
    `nSoftware License Agreement
    Electron.js Setup is licensed under the MIT License.
    By using this script, you agree to the following terms:
        1. You may use this script for personal or commercial projects.
        2. You may modify the script as needed.
        3. You may distribute the script to others.
        4. You may not hold the author liable for any damages.
        5. You must include the original license in all copies.
        
    Full license: https://raw.githubusercontent.com/fonseware/electronjs-setup/refs/heads/main/LICENSE
"@ -ForegroundColor Magenta
  Write-Host "`n(c) 2025 fonseware" -ForegroundColor Cyan
  Write-Host "GitHub Repo: https://github.com/fonseware/electronjs-setup" -ForegroundColor Cyan
}

function functionMainMenuChoices {
  param (
    [string]$Choice
  )

  switch ($Choice) {
    "1" { functionCheckForPrerequisites }
    "2" { functionCreateElectronAppDefault }
    "3" { functionCreateElectronAppVite }
    "4" { functionCreateElectronAppWindowsStyle }
    "5" { functionAboutScript }
    "6" { 
      functionDrawLogo
      Write-Host "Exiting script... Goodbye!" -ForegroundColor Yellow
      write-host "Thank you for using, and tell a friend about this script...  :)`n" -ForegroundColor Green
      Pause
      Clear-Host
      exit
      exit
      exit
      exit
      exit
    }
    default { 
      functionDrawLogo
      Write-Host "Invalid choice, please try again!" -ForegroundColor Red
    }
  }
}

function functionShowMainMenu {
  Write-Host @"
.--------------------------------------------------------------------------.
| Note: An active internet connection is required for this script to work. |
'--------------------------------------------------------------------------'`n
"@ -ForegroundColor Yellow
  Write-Host "[Main Menu]`n" -ForegroundColor Cyan
  Write-Host " 1. Check & install for prerequisites" -ForegroundColor Cyan
  Write-Host " 2. Create a new basic Electron.js app (default)" -ForegroundColor Cyan
  Write-Host " 3. Create a new Electron.js app using Vite templates" -ForegroundColor Cyan
  Write-Host " 4. Create a new Windows 10 style Electron.js app" -ForegroundColor Cyan
  Write-Host " 5. About this script" -ForegroundColor Cyan
  Write-Host " 6. Exit" -ForegroundColor Cyan
  Write-Host "`n(c) 2025 fonseware" -ForegroundColor Cyan
}

# Run the version comparison
functionDrawLogo2
functionShowInfoScreen
Pause
Compare-Versions
$localVersion = Get-LocalVersion
$localVersion = $localVersion.Trim()
# Main loop to keep the menu running
while ($true) {
  Set-Location $currentFolder
  functionDrawLogo
  functionShowMainMenu
  $varUserChoice = Read-Host "`nSelect an option (1-6)"
  functionMainMenuChoices -Choice $varUserChoice
  #functionDrawLogo
  Write-Host "`nPress [Enter] to go to main menu..." -ForegroundColor Magenta
  Read-Host  # Waits for user to press Enter before showing menu again
}