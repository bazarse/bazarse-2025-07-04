# 🔥 BAZARSE AUTO-SYNC INSTALLER - ONE-CLICK SETUP 🔥
# Run this script as Administrator ONCE to setup permanent auto-sync

param(
    [string]$ProjectPath = "C:\Users\vinam\Desktop\bazar se\bazarse"
)

Write-Host "🔥 BAZARSE AUTO-SYNC INSTALLER" -ForegroundColor Cyan
Write-Host ("=" * 50) -ForegroundColor Cyan

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "❌ Please run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Running as Administrator" -ForegroundColor Green

# Set execution policy
try {
    Write-Host "🔧 Setting PowerShell execution policy..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Force
    Write-Host "✅ Execution policy set" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to set execution policy: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Verify project path exists
if (-not (Test-Path $ProjectPath)) {
    Write-Host "❌ Project path not found: $ProjectPath" -ForegroundColor Red
    $ProjectPath = Read-Host "Enter correct path to Bazarse project"
    
    if (-not (Test-Path $ProjectPath)) {
        Write-Host "❌ Invalid path. Exiting..." -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ Project path verified: $ProjectPath" -ForegroundColor Green

# Check if Git repository
Set-Location $ProjectPath
$gitCheck = git status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Not a Git repository: $ProjectPath" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Git repository verified" -ForegroundColor Green

# Create the auto-sync script path
$scriptPath = Join-Path $ProjectPath "bazarse-auto-sync.ps1"

# Check if auto-sync script exists
if (-not (Test-Path $scriptPath)) {
    Write-Host "❌ Auto-sync script not found: $scriptPath" -ForegroundColor Red
    Write-Host "Please ensure bazarse-auto-sync.ps1 is in your project folder" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Auto-sync script found" -ForegroundColor Green

# Create Task Scheduler task
try {
    Write-Host "📅 Creating Windows Task Scheduler task..." -ForegroundColor Yellow
    
    $taskName = "BazarseAutoSync"
    $taskDescription = "Automatically syncs Bazarse project with Git repository"
    
    # Remove existing task if it exists
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    } catch {
        # Task doesn't exist, continue
    }
    
    # Create new task
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
    
    $trigger = New-ScheduledTaskTrigger -AtStartup
    
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
    
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType ServiceAccount -RunLevel Highest
    
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description $taskDescription
    
    Register-ScheduledTask -TaskName $taskName -InputObject $task -Force
    
    Write-Host "✅ Task Scheduler task created successfully!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Failed to create scheduled task: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test the task
try {
    Write-Host "🧪 Testing the scheduled task..." -ForegroundColor Yellow
    Start-ScheduledTask -TaskName $taskName
    Start-Sleep 3
    
    $taskInfo = Get-ScheduledTask -TaskName $taskName
    if ($taskInfo.State -eq "Running") {
        Write-Host "✅ Task is running successfully!" -ForegroundColor Green
        
        # Stop the test run
        Stop-ScheduledTask -TaskName $taskName
        Write-Host "✅ Test completed" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Task created but may have issues" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️ Task created but test failed: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Create desktop shortcut for manual control
try {
    Write-Host "🖥️ Creating desktop shortcuts..." -ForegroundColor Yellow
    
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    
    # Start Auto-Sync shortcut
    $startShortcut = Join-Path $desktopPath "Start Bazarse Auto-Sync.lnk"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($startShortcut)
    $Shortcut.TargetPath = "schtasks.exe"
    $Shortcut.Arguments = "/run /tn `"BazarseAutoSync`""
    $Shortcut.WorkingDirectory = $ProjectPath
    $Shortcut.IconLocation = "shell32.dll,137"
    $Shortcut.Description = "Start Bazarse Auto-Sync manually"
    $Shortcut.Save()
    
    # Stop Auto-Sync shortcut
    $stopShortcut = Join-Path $desktopPath "Stop Bazarse Auto-Sync.lnk"
    $Shortcut2 = $WshShell.CreateShortcut($stopShortcut)
    $Shortcut2.TargetPath = "schtasks.exe"
    $Shortcut2.Arguments = "/end /tn `"BazarseAutoSync`""
    $Shortcut2.WorkingDirectory = $ProjectPath
    $Shortcut2.IconLocation = "shell32.dll,131"
    $Shortcut2.Description = "Stop Bazarse Auto-Sync"
    $Shortcut2.Save()
    
    Write-Host "✅ Desktop shortcuts created" -ForegroundColor Green
    
} catch {
    Write-Host "⚠️ Desktop shortcuts creation failed: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Final summary
Write-Host ""
Write-Host "🎉 INSTALLATION COMPLETED SUCCESSFULLY!" -ForegroundColor Green
Write-Host ("=" * 50) -ForegroundColor Green
Write-Host ""
Write-Host "📋 WHAT WAS INSTALLED:" -ForegroundColor Cyan
Write-Host "✅ PowerShell execution policy set to RemoteSigned" -ForegroundColor White
Write-Host "✅ Windows Task Scheduler task 'BazarseAutoSync' created" -ForegroundColor White
Write-Host "✅ Task will start automatically with Windows" -ForegroundColor White
Write-Host "✅ Desktop shortcuts created for manual control" -ForegroundColor White
Write-Host ""
Write-Host "🔧 TASK DETAILS:" -ForegroundColor Cyan
Write-Host "📁 Project Path: $ProjectPath" -ForegroundColor White
Write-Host "📝 Script Path: $scriptPath" -ForegroundColor White
Write-Host "⏰ Checks for updates every 2 minutes" -ForegroundColor White
Write-Host "📊 Logs saved to: $(Join-Path $ProjectPath 'auto-sync.log')" -ForegroundColor White
Write-Host ""
Write-Host "🚀 NEXT STEPS:" -ForegroundColor Cyan
Write-Host "1. Restart your computer (or start task manually)" -ForegroundColor Yellow
Write-Host "2. Auto-sync will start automatically" -ForegroundColor Yellow
Write-Host "3. Check log file for sync status" -ForegroundColor Yellow
Write-Host "4. Use desktop shortcuts to start/stop manually" -ForegroundColor Yellow
Write-Host ""
Write-Host "🎯 TESTING:" -ForegroundColor Cyan
Write-Host "• Make a change in GitHub and push" -ForegroundColor White
Write-Host "• Within 2 minutes, changes will auto-pull" -ForegroundColor White
Write-Host "• You'll get a notification when sync happens" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"
