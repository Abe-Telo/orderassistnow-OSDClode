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
    $path = "${drive}:\OSDCloud\Repo\orderassistnow-OSDClode\$fileName"
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
        $localTaskbarPath = "${drives[0]}:\OSDCloud\Repo\orderassistnow-OSDClode\taskbar.ps1"
        Invoke-WebRequest -Uri $onlineTaskbarURL -OutFile $localTaskbarPath -ErrorAction Stop
        Write-Host "Downloaded taskbar.ps1 to $localTaskbarPath"
    } catch {
        Write-Host "Failed to download taskbar.ps1. Please check your internet connection or the URL."
        exit 1
    }
}

# Run the taskbar.ps1 script in a new, hidden PowerShell process
if (Test-Path $localTaskbarPath) {
    Write-Host "Running taskbar.ps1 in a separate PowerShell window (minimized)..."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File `"$localTaskbarPath`"" -WindowStyle Minimized
} else {
    Write-Host "taskbar.ps1 is not available to run."
}

# Function to check internet connectivity
function Test-InternetConnection {
    try {
        $result = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet
        return $result
    } catch {
        return $false
    }
}

# Prompt to ask if the user wants to wait for Wi-Fi connection
do {
    $response = [System.Windows.Forms.MessageBox]::Show("Please open WirelessConnect from taskbar to connect to Wi-Fi. Do you want to wait for Wi-Fi before continuing?", "Wi-Fi Connection", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    
    if ($response -eq [System.Windows.Forms.DialogResult]::Yes) {
        Write-Host "Checking internet connection..."
        $internetConnected = Test-InternetConnection
        if (-not $internetConnected) {
            Write-Host "No internet connection detected, retrying..."
        }
    } else {
        Write-Host "User chose not to wait for Wi-Fi. Continuing..."
        break
    }
} while (-not $internetConnected)

# If update.ps1 not found, download it from GitHub to the first available drive
if (-not $localUpdatePath) {
    Write-Host "update.ps1 not found locally, downloading from GitHub..."
    try {
        $localUpdatePath = "${drives[0]}:\OSDCloud\Repo\orderassistnow-OSDClode\update.ps1"
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
