# Define local drive options
$drives = @("C", "D", "E", "X")

# Define paths for taskbar.ps1 and update.ps1 on each drive
$localTaskbarPath = ""
$localUpdatePath = ""

# Define online URLs
$onlineTaskbarURL = "https://raw.githubusercontent.com/Abe-Telo/orderassistnow-OSDClode/main/taskbar.ps1"
$onlineUpdateURL = "https://raw.githubusercontent.com/Abe-Telo/orderassistnow-OSDClode/main/update.ps1"

# Function to check if the file exists in the OSDCloud path on a given drive
function Get-FilePath {
    param (
        [string]$drive,
        [string]$fileName
    )
    $path = "$drive:\OSDCloud\Repo\orderassistnow-OSDClode\$fileName"
    if (Test-Path $path) {
        return $path
    } else {
        return $null
    }
}

# Check all drives for taskbar.ps1 and update.ps1
foreach ($drive in $drives) {
    if (-not $localTaskbarPath) {
        $localTaskbarPath = Get-FilePath -drive $drive -fileName "taskbar.ps1"
    }
    if (-not $localUpdatePath) {
        $localUpdatePath = Get-FilePath -drive $drive -fileName "update.ps1"
    }
}

# If taskbar.ps1 not found, download it from GitHub to the first available drive
if (-not $localTaskbarPath) {
    Write-Host "taskbar.ps1 not found locally, downloading from GitHub..."
    $localTaskbarPath = "$($drives[0]):\OSDCloud\Repo\orderassistnow-OSDClode\taskbar.ps1"
    Invoke-WebRequest -Uri $onlineTaskbarURL -OutFile $localTaskbarPath
    Write-Host "Downloaded taskbar.ps1 to $localTaskbarPath"
}

# Run the taskbar.ps1 script
Write-Host "Running taskbar.ps1..."
& $localTaskbarPath

# If update.ps1 not found, download it from GitHub to the first available drive
if (-not $localUpdatePath) {
    Write-Host "update.ps1 not found locally, downloading from GitHub..."
    $localUpdatePath = "$($drives[0]):\OSDCloud\Repo\orderassistnow-OSDClode\update.ps1"
    Invoke-WebRequest -Uri $onlineUpdateURL -OutFile $localUpdatePath
    Write-Host "Downloaded update.ps1 to $localUpdatePath"
}

# Run the update.ps1 script
Write-Host "Running update.ps1..."
& $localUpdatePath
