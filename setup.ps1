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
A powerful and easy-to-use script designed to quickly set up your Electron.js
projects. Whether you're a beginner or an experienced developer, this script 
will streamline the process of creating a new Electron app from scratch.`n
* No need to manually configure your project. Just answer a few simple 
prompts, and the script does the rest.`n
* It automatically checks and installs essential tools such as Chocolatey, 
Visual Studio Code, and Node.js.`n
* It creates a new Electron project directory, sets up npm, installs Electron,
 and generates the essential files (like main.js and index.html).`n
* Once your project is set up, the script opens it directly in Visual Studio 
Code, so you can start coding right away.`n
* From initializing your project to launching the app, the script takes care 
of every step, so you don't have to.`n
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
    if (-not (Test-InternetConnection)) {
      Write-Host "No internet connection. Please connect to the internet and try again." -ForegroundColor Red
      return
    }
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
  Write-Host "[-] Visual Studio Code"-ForegroundColor Yellow

  $nodePath = Get-Command 'node' -ErrorAction SilentlyContinue
  if (-not $nodePath) {
    Write-Host "`nNode.js is not installed. Installing Node.js..." -ForegroundColor Yellow
    choco install nodejs -y
  }
  else {
    Write-Host "`nNode.js is already installed." -ForegroundColor Green
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
  if (-not (Test-InternetConnection)) {
    Write-Host "No internet connection. Please connect to the internet and try again." -ForegroundColor Red
    return
  }

  #Write-Host "Internet is available. Proceeding with npm project creation..."

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
  Write-Host "`nPress [Enter] to continue or type '1' to go to main menu,`n to start over..."
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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Electron.js App</title>
</head>
<body>
    <h1>Hello from Electron!</h1>
    <h2>Congratulations on setting up Electron.js on VS Code.</h2>
    <p>Welcome to your Electron app. Edit the index.html file and start creating, your dream project!</p>
    <p>This file was created from the Electron.js Setup script. Thank you and tell a friend about this script.</p>
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
    if (-not (Test-InternetConnection)) {
      Write-Host "No internet connection. Please connect to the internet and try again." -ForegroundColor Red
      return
    }
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
  Write-Host "`nPress [Enter] to continue or type '1' to go to main menu,`n to start over..."
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
    <title>Hello World! $projectName</title>
    <link rel="stylesheet" href="style.css" />
  </head>
  <body>
    <header id="titlebar">
      <div id="drag-region">
        <div id="window-title">
          <span>Electron quick start</span>
        </div>

        <div id="window-controls">
          <div class="button" id="min-button">
            <img
              class="icon"
              srcset="icons/min-w-10.png 1x, icons/min-w-12.png 1.25x, icons/min-w-15.png 1.5x, icons/min-w-15.png 1.75x, icons/min-w-20.png 2x, icons/min-w-20.png 2.25x, icons/min-w-24.png 2.5x, icons/min-w-30.png 3x, icons/min-w-30.png 3.5x"
              draggable="false"
            />
          </div>
          <div class="button" id="max-button">
            <img
              class="icon"
              srcset="icons/max-w-10.png 1x, icons/max-w-12.png 1.25x, icons/max-w-15.png 1.5x, icons/max-w-15.png 1.75x, icons/max-w-20.png 2x, icons/max-w-20.png 2.25x, icons/max-w-24.png 2.5x, icons/max-w-30.png 3x, icons/max-w-30.png 3.5x"
              draggable="false"
            />
          </div>
          <div class="button" id="restore-button">
            <img
              class="icon"
              srcset="icons/restore-w-10.png 1x, icons/restore-w-12.png 1.25x, icons/restore-w-15.png 1.5x, icons/restore-w-15.png 1.75x, icons/restore-w-20.png 2x, icons/restore-w-20.png 2.25x, icons/restore-w-24.png 2.5x, icons/restore-w-30.png 3x, icons/restore-w-30.png 3.5x"
              draggable="false"
            />
          </div>
          <div class="button" id="close-button">
            <img
              class="icon"
              srcset="icons/close-w-10.png 1x, icons/close-w-12.png 1.25x, icons/close-w-15.png 1.5x, icons/close-w-15.png 1.75x, icons/close-w-20.png 2x, icons/close-w-20.png 2.25x, icons/close-w-24.png 2.5x, icons/close-w-30.png 3x, icons/close-w-30.png 3.5x"
              draggable="false"
            />
          </div>
        </div>
      </div>
    </header>

    <div id="main">
      <h1>Hello World!</h1>
      <p>Electron version: <span id="electron-ver"></span></p>
      <p>
      Welcome to your new project, $projectName. This is a fork of this project from GitHub <a href="https://github.com/binaryfunt/electron-seamless-titlebar-tutorial">Visit Electron Seamless Titlebar Tutorial. This part of the project is created using the Electron.JS Setup. Tell a friend about this script. For any issues please submit them on the project page.</a>
      </p>
    </div>

    <script src="renderer.js"></script>
  </body>
</html>
"@
  Set-Content -Path (Join-Path -Path $fullPath -ChildPath "index.html") -Value $htmlContent
  Start-Sleep -Seconds 1
  $cssContent = @"
/* Basic styling */
* {margin: 0; padding: 0; border: 0; vertical-align: baseline;}
html {box-sizing: border-box;}
*, *:before, *:after {box-sizing: inherit;}
html, body {height: 100%; margin: 0;}

body {
  font-family: "Segoe UI", sans-serif;
  background: #1A2933;
  color: #FFF;
}

h1 {
  margin: 0 0 10px 0;
  font-weight: 600;
  line-height: 1.2;
}

p {
  margin-top: 10px;
  color: rgba(255,255,255,0.4);
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
  color: #FFF;
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

@media (-webkit-device-pixel-ratio: 1.5), (device-pixel-ratio: 1.5),
(-webkit-device-pixel-ratio: 2), (device-pixel-ratio: 2),
(-webkit-device-pixel-ratio: 3), (device-pixel-ratio: 3) {
  #window-controls .icon {
    width: 10px;
    height: 10px;
  }
}

#window-controls .button {
  user-select: none;
}

#window-controls .button:hover {
  background: rgba(255,255,255,0.1);
}

#window-controls .button:active {
  background: rgba(255,255,255,0.2);
}

#close-button:hover {
  background: #E81123 !important;
}

#close-button:active {
  background: #F1707A !important;
}
#close-button:active .icon {
  filter: invert(1);
}

#min-button {
  grid-column: 1;
}
#max-button, #restore-button {
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
  Write-Host "About this script`nScript version: $localVersion`n" -ForegroundColor Cyan
  Write-Host " * This script is designed to help you create a new Electron.js app with ease." -ForegroundColor Yellow
  Write-Host " * It will guide you through the process of setting up a new Electron app." -ForegroundColor Yellow
  Write-Host " * The script will check for prerequisites and install them if needed." -ForegroundColor Yellow
  Write-Host " * It will then create a new Electron app with the default settings." -ForegroundColor Yellow
  Write-Host " * You can also create a new Electron app with Vite, a faster and more efficient way to create apps." -ForegroundColor Yellow
  Write-Host " * You can now create a new Windows style Electron apps." -ForegroundColor Yellow
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