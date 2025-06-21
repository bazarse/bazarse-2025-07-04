# 🔥 BAZARSE AUTO-SYNC SETUP 🔥
# Simple installer that works

Write-Host "🔥 BAZARSE AUTO-SYNC SETUP" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan

# Check Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "❌ Please run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "✅ Running as Administrator" -ForegroundColor Green

# Project path
$ProjectPath = "C:\Users\vinam\Desktop\bazar se\bazarse"
$scriptPath = Join-Path $ProjectPath "simple-auto-sync.ps1"

Write-Host "📁 Project: $ProjectPath" -ForegroundColor White
Write-Host "📝 Script: $scriptPath" -ForegroundColor White

# Check project exists
if (-not (Test-Path $ProjectPath)) {
    Write-Host "❌ Project path not found!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# Check script exists
if (-not (Test-Path $scriptPath)) {
    Write-Host "❌ Auto-sync script not found!" -ForegroundColor Red
    Write-Host "Creating simple-auto-sync.ps1..." -ForegroundColor Yellow
    
    # Create the script if it doesn't exist
    $scriptContent = @'
# 🔥 SIMPLE BAZARSE AUTO-SYNC 🔥
$ProjectPath = "C:\Users\vinam\Desktop\bazar se\bazarse"
$logFile = Join-Path $ProjectPath "auto-sync.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Host $logEntry
    try {
        Add-Content -Path $logFile -Value $logEntry
    } catch {}
}

Write-Log "🔥 Bazarse Auto-Sync Started!"
Set-Location $ProjectPath

while ($true) {
    try {
        git fetch origin 2>$null
        $behind = git rev-list --count HEAD..origin/master 2>$null
        
        if ($behind -and [int]$behind -gt 0) {
            Write-Log "📥 Pulling $behind new commits..."
            git pull origin master 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Log "✅ Successfully updated!"
            }
        } else {
            Write-Log "✅ Up to date"
        }
        
        Start-Sleep 120
    } catch {
        Write-Log "❌ Error: $($_.Exception.Message)"
        Start-Sleep 60
    }
}
'@
    
    try {
        $scriptContent | Out-File -FilePath $scriptPath -Encoding UTF8
        Write-Host "✅ Script created!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to create script!" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit
    }
}

Write-Host "✅ Auto-sync script found" -ForegroundColor Green

# Set execution policy
Write-Host "🔧 Setting execution policy..." -ForegroundColor Yellow
try {
    Set-ExecutionPolicy RemoteSigned -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Execution policy set" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Execution policy warning (but continuing)" -ForegroundColor Yellow
}

# Create scheduled task
Write-Host "📅 Creating scheduled task..." -ForegroundColor Yellow

$taskName = "BazarseAutoSync"

# Remove existing task if exists
try {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "🗑️ Removed existing task" -ForegroundColor Yellow
} catch {
    # Task doesn't exist
}

# Create new task
try {
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType ServiceAccount -RunLevel Highest
    
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "Bazarse Auto-Sync"
    Register-ScheduledTask -TaskName $taskName -InputObject $task -Force | Out-Null
    
    Write-Host "✅ Scheduled task created!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create task: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# Test the task
Write-Host "🧪 Testing task..." -ForegroundColor Yellow
try {
    Start-ScheduledTask -TaskName $taskName
    Start-Sleep 5
    
    $taskInfo = Get-ScheduledTask -TaskName $taskName
    if ($taskInfo.State -eq "Running") {
        Write-Host "✅ Task is running!" -ForegroundColor Green
        Stop-ScheduledTask -TaskName $taskName
        Write-Host "✅ Test completed" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Task created but not running" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️ Task test failed but task is created" -ForegroundColor Yellow
}

# Create desktop shortcuts
Write-Host "🖥️ Creating desktop shortcuts..." -ForegroundColor Yellow
try {
    $desktop = [Environment]::GetFolderPath("Desktop")
    
    # Start shortcut
    $WshShell = New-Object -comObject WScript.Shell
    $startShortcut = $WshShell.CreateShortcut("$desktop\Start Bazarse Auto-Sync.lnk")
    $startShortcut.TargetPath = "schtasks.exe"
    $startShortcut.Arguments = "/run /tn `"BazarseAutoSync`""
    $startShortcut.Save()
    
    # Stop shortcut
    $stopShortcut = $WshShell.CreateShortcut("$desktop\Stop Bazarse Auto-Sync.lnk")
    $stopShortcut.TargetPath = "schtasks.exe"
    $stopShortcut.Arguments = "/end /tn `"BazarseAutoSync`""
    $stopShortcut.Save()
    
    Write-Host "✅ Desktop shortcuts created!" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Shortcuts creation failed" -ForegroundColor Yellow
}

# Final message
Write-Host ""
Write-Host "🎉 SETUP COMPLETED!" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Auto-sync task created" -ForegroundColor White
Write-Host "✅ Will start automatically with Windows" -ForegroundColor White
Write-Host "✅ Desktop shortcuts created" -ForegroundColor White
Write-Host "✅ Logs will be in: auto-sync.log" -ForegroundColor White
Write-Host ""
Write-Host "🚀 NEXT STEPS:" -ForegroundColor Cyan
Write-Host "1. Restart your computer" -ForegroundColor Yellow
Write-Host "2. Auto-sync will start automatically" -ForegroundColor Yellow
Write-Host "3. Check auto-sync.log for activity" -ForegroundColor Yellow
Write-Host ""
Write-Host "🎯 MANUAL CONTROLS:" -ForegroundColor Cyan
Write-Host "Start: Use desktop shortcut or run 'Start-ScheduledTask BazarseAutoSync'" -ForegroundColor White
Write-Host "Stop: Use desktop shortcut or run 'Stop-ScheduledTask BazarseAutoSync'" -ForegroundColor White
Write-Host "Status: Run 'Get-ScheduledTask BazarseAutoSync'" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"
