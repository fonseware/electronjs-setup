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

$host.UI.RawUI.WindowTitle = "Electron.JS Setup"
$host.UI.RawUI.ForegroundColor = "White"
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
                                      |__/                         |_|    v1.3
_______________________________________________________________________________

"@ -ForegroundColor Green
}

function functionShowMainMenu {
    Write-Host @"
.--------------------------------------------------------------------------.
| Note: An active internet connection is required for this script to work. |
'--------------------------------------------------------------------------'

"@ -ForegroundColor Yellow
    Write-Host " Main Menu" -ForegroundColor Cyan
    Write-Host " 1. Check & install for prerequisites" -ForegroundColor Cyan
    Write-Host " 2. Create a new Electron.JS app (default)" -ForegroundColor Cyan
    Write-Host " 3. Create a new Electron.JS app with Vite" -ForegroundColor DarkGray
    Write-Host " 4. About this script" -ForegroundColor Cyan
    Write-Host " 5. Exit" -ForegroundColor Cyan
    Write-Host "`n(c) 2025 fonseware" -ForegroundColor Cyan
}

function functionDrawLine {
    Write-Host "_______________________________________________________________________________" -ForegroundColor Yellow
}

function functionCheckForPrerequisites {
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
    Write-Host "Creating a new Electron.JS app..." -ForegroundColor Yellow
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
    Write-Host "Project Location: $projectLocation\$projectName" -ForegroundColor Yellow
    functionDrawLine
    Write-Host "`nPress [Enter] to continue or type '1' to start over..."
    $inputValue = Read-Host "Enter your choice"
    if ($inputValue -eq "1") {
        Write-Host "`nOkay, exiting script..." -ForegroundColor Yellow
        return
    } 
    if ($inputValue -eq "") {} else {
        Write-Host "`nInvalid input.... Exiting script" -ForegroundColor Red
        return
    }
    functionDrawLogo
    Write-Host "Creating a new Electron.JS app..." -ForegroundColor Yellow
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
    Write-Host "Creating a new Electron.JS app..." -ForegroundColor Yellow
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
    Write-Host "Creating a new Electron.JS app..." -ForegroundColor Yellow
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
    Write-Host "Creating a new Electron.JS app..." -ForegroundColor Yellow
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
    <title>ElectronJS App</title>
</head>
<body>
    <h1>Hello from Electron!</h1>
    <h2>Congratulations on setting up ElectronJS on VS Code.</h2>
    <p>Welcome to your Electron app. Edit the index.html file and start creating, your dream project!</p>
    <p>This file was created from the ElectronJS Setup script. Thank you and tell a friend about this script.</p>
</body>
</html>
"@
    Set-Content -Path (Join-Path -Path $fullPath -ChildPath "index.html") -Value $htmlContent
    Start-Sleep -Seconds 1
    functionDrawLogo
    Write-Host "Creating a new Electron.JS app..." -ForegroundColor Yellow
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
    Write-Host "Creating a new Electron.JS app..." -ForegroundColor Yellow
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
    Write-Host "Creating a new Electron.JS app..." -ForegroundColor Yellow
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
    Write-Host "Creating a new Electron.JS app..." -ForegroundColor Yellow
    Write-Host "[*] Step 1: Name of the project"-ForegroundColor Green
    Write-Host "[*] Step 2: Creating project directory and initialise npm"-ForegroundColor Green
    Write-Host "[*] Step 3: Installing Electron to project"-ForegroundColor Green
    Write-Host "[*] Step 4: Creating main.js file"-ForegroundColor Green
    Write-Host "[*] Step 5: Creating index.html file"-ForegroundColor Green
    Write-Host "[*] Step 6: Updating package.json file"-ForegroundColor Green
    Write-Host "[*] Step 7: Opening project in Visual Studio Code"-ForegroundColor Green
    Write-Host "[*] Step 8: Building Electron app"-ForegroundColor Green
    write-host "`nYour Electron app has been created successfully!" -ForegroundColor Green
    write-host "`nThank you for using the ElectronJS Setup script." -ForegroundColor Green
}

function functionCreateElectronAppVite {
    functionDrawLogo
    Write-Host "Sorry! This feature is still under development." -ForegroundColor Red
}

function functionAboutScript {
    functionDrawLogo
    Write-Host "About this script" -ForegroundColor Cyan
    Write-Host " * This script is designed to help you create a new Electron.JS app with ease." -ForegroundColor Yellow
    Write-Host " * It will guide you through the process of setting up a new Electron app." -ForegroundColor Yellow
    Write-Host " * The script will check for prerequisites and install them if needed." -ForegroundColor Yellow
    Write-Host " * It will then create a new Electron app with the default settings." -ForegroundColor Yellow
    Write-Host " * You can also create a new Electron app with Vite, a faster and more efficient way to create apps." -ForegroundColor Yellow
    Write-Host @"
    `nSoftware License Agreement
    ElectronJS Setup is licensed under the MIT License.
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
        "4" { functionAboutScript }
        "5" { 
            functionDrawLogo
            Write-Host "Exiting script... Goodbye!" -ForegroundColor Red
            write-host "Thank you for using...  :)" -ForegroundColor Green
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

# Main loop to keep the menu running
while ($true) {
    functionDrawLogo
    functionShowMainMenu
    $varUserChoice = Read-Host "`nSelect an option (1-5)"
    functionMainMenuChoices -Choice $varUserChoice
    #functionDrawLogo
    Write-Host "`nPress [Enter] to go to main menu..." -ForegroundColor Magenta
    Read-Host  # Waits for user to press Enter before showing menu again
}
