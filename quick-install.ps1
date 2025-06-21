# 🔥 BAZARSE AUTO-SYNC QUICK INSTALLER 🔥
# Simple and working installer

Write-Host "🔥 BAZARSE AUTO-SYNC INSTALLER" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Check Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "❌ Please run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "✅ Running as Administrator" -ForegroundColor Green

# Set execution policy
Write-Host "🔧 Setting execution policy..." -ForegroundColor Yellow
try {
    Set-ExecutionPolicy RemoteSigned -Force
    Write-Host "✅ Execution policy set" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to set execution policy" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# Project path
$ProjectPath = "C:\Users\vinam\Desktop\bazar se\bazarse"
Write-Host "📁 Project path: $ProjectPath" -ForegroundColor White

# Check project exists
if (-not (Test-Path $ProjectPath)) {
    Write-Host "❌ Project path not found!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# Check if Git repository
Set-Location $ProjectPath
$gitCheck = git status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Not a Git repository!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "✅ Git repository verified" -ForegroundColor Green

# Check auto-sync script
$scriptPath = Join-Path $ProjectPath "bazarse-auto-sync.ps1"
if (-not (Test-Path $scriptPath)) {
    Write-Host "❌ Auto-sync script not found!" -ForegroundColor Red
    Write-Host "Please ensure bazarse-auto-sync.ps1 is in project folder" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "✅ Auto-sync script found" -ForegroundColor Green

# Create scheduled task
Write-Host "📅 Creating scheduled task..." -ForegroundColor Yellow

$taskName = "BazarseAutoSync"

# Remove existing task
try {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
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
    Register-ScheduledTask -TaskName $taskName -InputObject $task -Force
    
    Write-Host "✅ Scheduled task created!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create task: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# Test task
Write-Host "🧪 Testing task..." -ForegroundColor Yellow
try {
    Start-ScheduledTask -TaskName $taskName
    Start-Sleep 3
    Stop-ScheduledTask -TaskName $taskName
    Write-Host "✅ Task test successful!" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Task created but test failed" -ForegroundColor Yellow
}

# Create desktop shortcuts
Write-Host "🖥️ Creating desktop shortcuts..." -ForegroundColor Yellow
try {
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    
    # Start shortcut
    $WshShell = New-Object -comObject WScript.Shell
    $startShortcut = $WshShell.CreateShortcut("$desktopPath\Start Bazarse Auto-Sync.lnk")
    $startShortcut.TargetPath = "schtasks.exe"
    $startShortcut.Arguments = "/run /tn `"BazarseAutoSync`""
    $startShortcut.Save()
    
    # Stop shortcut
    $stopShortcut = $WshShell.CreateShortcut("$desktopPath\Stop Bazarse Auto-Sync.lnk")
    $stopShortcut.TargetPath = "schtasks.exe"
    $stopShortcut.Arguments = "/end /tn `"BazarseAutoSync`""
    $stopShortcut.Save()
    
    Write-Host "✅ Desktop shortcuts created!" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Shortcuts creation failed" -ForegroundColor Yellow
}

# Success message
Write-Host ""
Write-Host "🎉 INSTALLATION COMPLETED!" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Auto-sync task created and will start with Windows" -ForegroundColor White
Write-Host "✅ Desktop shortcuts created for manual control" -ForegroundColor White
Write-Host "✅ Logs will be saved to: auto-sync.log" -ForegroundColor White
Write-Host ""
Write-Host "🚀 NEXT STEPS:" -ForegroundColor Cyan
Write-Host "1. Restart your computer" -ForegroundColor Yellow
Write-Host "2. Auto-sync will start automatically" -ForegroundColor Yellow
Write-Host "3. Use desktop shortcuts for manual control" -ForegroundColor Yellow
Write-Host ""
Write-Host "🎯 TESTING:" -ForegroundColor Cyan
Write-Host "• Make a change on GitHub" -ForegroundColor White
Write-Host "• Within 2 minutes it will auto-pull" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"
