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
__________________________________________SCRIPT INSTALLTION GUIDE_____________

"@ -ForegroundColor Green
}

function functionDrawLine {
    Write-Host "_______________________________________________________________________________" -ForegroundColor Yellow
}

function functionShowMenu {

}

# Define repository details
$repoUrl = "https://github.com/fonseware/electronjs-setup.git"
$repoDir = "electronjs-setup" # Folder where the repo will be cloned or updated
$versionFile = "version.txt"  # Path to version.txt in the GitHub repo

# Hardcoded version in the script
$hardcodedVersion = "1.4"

# Path to version.txt file in the repo
$versionFilePath = Join-Path $repoDir $versionFile

# Function to compare versions
function Compare-Version($currentVersion, $newVersion) {
    $currentVersionParts = $currentVersion.Split(".")
    $newVersionParts = $newVersion.Split(".")
    
    for ($i = 0; $i -lt $currentVersionParts.Length; $i++) {
        if ($currentVersionParts[$i] -lt $newVersionParts[$i]) {
            return $true
        } elseif ($currentVersionParts[$i] -gt $newVersionParts[$i]) {
            return $false
        }
    }
    return $false
}

functionDrawLogo
functionShowMenu
Pause
functionDrawLogo

# Check if repo exists
if (Test-Path $repoDir) {
    Write-Host "Repo already cloned. Checking for updates..."

    # Fetch the latest commit and read the version from version.txt
    git -C $repoDir pull

    $remoteVersion = Get-Content $versionFilePath -Raw

    # Compare versions
    if (Compare-Version $hardcodedVersion $remoteVersion) {
        Write-Host "An update is available. Updating repo..."

        # Delete the folder contents and clone the latest version
        Remove-Item -Recurse -Force $repoDir
        git clone -b main $repoUrl
    } else {
        Write-Host "Repo is up-to-date. Running electronjs-setup.ps1..."
        .\electronjs-setup.ps1
    }
} else {
    Write-Host "Repo not found. Cloning the repository..."

    # Clone the repository
    git clone -b main $repoUrl

    # Read the version from the newly cloned repo
    $remoteVersion = Get-Content $versionFilePath -Raw

    # Compare with the hardcoded version
    if (Compare-Version $hardcodedVersion $remoteVersion) {
        Write-Host "An update is available. Updating repo..."
        
        # Delete the folder contents and clone the latest version
        Remove-Item -Recurse -Force $repoDir
        git clone -b main $repoUrl
    }

    # Run the electron-setup script
    .\electronjs-setup.ps1
}
