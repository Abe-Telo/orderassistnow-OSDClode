# Add this file to C:\OSDCloudUSBDriver\Media\OSDCloud\Repo\orderassistnow-OSDClode

# Define local file paths
$localTaskbarPath = "C:\OSDCloud\Repo\orderassistnow-OSDClode\taskbar.ps1"
$localUpdatePath = "C:\OSDCloud\Repo\orderassistnow-OSDClode\update.ps1"

# Define online URLs
$onlineTaskbarURL = "https://raw.githubusercontent.com/Abe-Telo/orderassistnow-OSDClode/main/taskbar.ps1"
$onlineUpdateURL = "https://raw.githubusercontent.com/Abe-Telo/orderassistnow-OSDClode/main/update.ps1"

# Check if taskbar.ps1 exists locally, if not download from GitHub
if (Test-Path $localTaskbarPath) {
    Write-Host "Found taskbar.ps1 locally, running the script..."
    & $localTaskbarPath
} else {
    Write-Host "taskbar.ps1 not found locally, downloading from GitHub..."
    Invoke-WebRequest -Uri $onlineTaskbarURL -OutFile $localTaskbarPath
    Write-Host "Downloaded taskbar.ps1, running the script..."
    & $localTaskbarPath
}

# Check if update.ps1 exists locally, if not download from GitHub
if (Test-Path $localUpdatePath) {
    Write-Host "Found update.ps1 locally, running the script..."
    & $localUpdatePath
} else {
    Write-Host "update.ps1 not found locally, downloading from GitHub..."
    Invoke-WebRequest -Uri $onlineUpdateURL -OutFile $localUpdatePath
    Write-Host "Downloaded update.ps1, running the script..."
    & $localUpdatePath
}
