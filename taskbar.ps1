# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form (taskbar)
$taskbar = New-Object System.Windows.Forms.Form
$taskbar.Text = "Custom Taskbar"
$taskbar.BackColor = [System.Drawing.Color]::Blue  # Set background color to blue
$taskbar.FormBorderStyle = 'None'
$taskbar.Width = 300
$taskbar.Height = 40
$taskbar.StartPosition = 'Manual'
$taskbar.Top = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height - $taskbar.Height
$taskbar.Left = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width - $taskbar.Width

# Function to check if a process is running
function IsProcessRunning($processName) {
    Get-Process -Name $processName -ErrorAction SilentlyContinue
}

# Add C# code to invoke touch keyboard
Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class TipHelper
    {
        [DllImport("user32.dll", SetLastError = false)]
        public static extern IntPtr GetDesktopWindow();

        [ComImport, Guid("4ce576fa-83dc-4F88-951c-9d0782b4e376")]
        public class UIHostNoLaunch
        {
        }

        [ComImport, Guid("37c994e7-432b-4834-a2f7-dce1f13b834b")]
        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        public interface ITipInvocation
        {
            void Toggle(IntPtr hwnd);
        }

        public static void ShowTouchKeyboard()
        {
            var uiHostNoLaunch = new UIHostNoLaunch();
            ITipInvocation tipInvocation = (ITipInvocation)uiHostNoLaunch;
            tipInvocation.Toggle(GetDesktopWindow());
            Marshal.ReleaseComObject(uiHostNoLaunch);
        }
    }
"@

# Button 1 - Open On-Screen Keyboard using the working method
$button1 = New-Object System.Windows.Forms.Button
$button1.Text = "Keyboard"
$button1.BackColor = 'White'
$button1.ForeColor = 'Black'
$button1.Width = 100
$button1.Height = 30
$button1.Top = 5
$button1.Left = 10
$button1.Add_Click({
    # Invoke the touch keyboard
    [TipHelper]::ShowTouchKeyboard()
})

# Button 2 - Toggle WirelessConnect.exe
$button2 = New-Object System.Windows.Forms.Button
$button2.Text = "WirelessConnect"
$button2.BackColor = 'White'
$button2.ForeColor = 'Black'
$button2.Width = 100
$button2.Height = 30
$button2.Top = 5
$button2.Left = 120
$button2.Add_Click({
    # Check if WirelessConnect.exe is running
    $process = IsProcessRunning "WirelessConnect"
    if ($process) {
        # If running, terminate it
        $process | Stop-Process
    } else {
        # If not running, start it
        Start-Process "X:\windows\system32\WirelessConnect.exe"
    }
})

# Add buttons to the taskbar
$taskbar.Controls.Add($button1)
$taskbar.Controls.Add($button2)

# Make the taskbar always on top
$taskbar.TopMost = $true

# Show the taskbar
$taskbar.ShowDialog()
