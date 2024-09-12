# Define local drive options
$drives = @("C", "D", "E", "X")

# Define paths for taskbar.ps1 and update.ps1 on each drive
$localTaskbarPath = $null
$localUpdatePath = $null

# Define online URLs
$onlineTaskbarURL = "https://raw.githubusercontent.com/Abe-Telo/orderassistnow-OSDClode/main/taskbar.ps1"
$onlineUpdateURL = "https://raw.githubusercontent.com/Abe-Telo/orderassistnow-OSDClode/main/update.ps1"

# Function to check if the file exists in the OSDCloud path on a given drive
function Get-FilePath {
    param (
        [string]$drive,
        [string]$fileName
    )
    $path = "${drive}:\OSDCloud\Repo\orderassistnow-OSDClode\$fileName"  # Correct variable usage here
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
    try {
        $localTaskbarPath = "${drives[0]}:\OSDCloud\Repo\orderassistnow-OSDClode\taskbar.ps1"  # Correct reference here too
        Invoke-WebRequest -Uri $onlineTaskbarURL -OutFile $localTaskbarPath -ErrorAction Stop
        Write-Host "Downloaded taskbar.ps1 to $localTaskbarPath"
    } catch {
        Write-Host "Failed to download taskbar.ps1. Please check your internet connection or the URL."
        exit 1
    }
}

# Run the taskbar.ps1 script if available
if (Test-Path $localTaskbarPath) {
    Write-Host "Running taskbar.ps1..."
    & $localTaskbarPath
} else {
    Write-Host "taskbar.ps1 is not available to run."
}

# If update.ps1 not found, download it from GitHub to the first available drive
if (-not $localUpdatePath) {
    Write-Host "update.ps1 not found locally, downloading from GitHub..."
    try {
        $localUpdatePath = "${drives[0]}:\OSDCloud\Repo\orderassistnow-OSDClode\update.ps1"  # Correct reference here too
        Invoke-WebRequest -Uri $onlineUpdateURL -OutFile $localUpdatePath -ErrorAction Stop
        Write-Host "Downloaded update.ps1 to $localUpdatePath"
    } catch {
        Write-Host "Failed to download update.ps1. Please check your internet connection or the URL."
        exit 1
    }
}

# Run the update.ps1 script if available
if (Test-Path $localUpdatePath) {
    Write-Host "Running update.ps1..."
    & $localUpdatePath
} else {
    Write-Host "update.ps1 is not available to run."
}
