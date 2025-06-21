# 🔥 BAZARSE AUTO-SYNC CONTROL PANEL 🔥
# Quick controls for managing auto-sync

param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "restart", "status", "logs", "test")]
    [string]$Action = "status"
)

$taskName = "BazarseAutoSync"
$projectPath = "C:\Users\vinam\Desktop\bazar se\bazarse"
$logFile = Join-Path $projectPath "auto-sync.log"

function Show-Header {
    Write-Host ""
    Write-Host "🔥 BAZARSE AUTO-SYNC CONTROL PANEL 🔥" -ForegroundColor Cyan
    Write-Host "=" * 45 -ForegroundColor Cyan
    Write-Host ""
}

function Get-TaskStatus {
    try {
        $task = Get-ScheduledTask -TaskName $taskName -ErrorAction Stop
        return @{
            Exists = $true
            State = $task.State
            LastRunTime = (Get-ScheduledTaskInfo -TaskName $taskName).LastRunTime
            NextRunTime = (Get-ScheduledTaskInfo -TaskName $taskName).NextRunTime
        }
    } catch {
        return @{
            Exists = $false
            State = "Not Found"
        }
    }
}

function Start-AutoSync {
    try {
        Start-ScheduledTask -TaskName $taskName
        Write-Host "✅ Auto-sync started successfully!" -ForegroundColor Green
        Start-Sleep 2
        Show-Status
    } catch {
        Write-Host "❌ Failed to start auto-sync: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Stop-AutoSync {
    try {
        Stop-ScheduledTask -TaskName $taskName
        Write-Host "🛑 Auto-sync stopped successfully!" -ForegroundColor Yellow
        Show-Status
    } catch {
        Write-Host "❌ Failed to stop auto-sync: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Restart-AutoSync {
    Write-Host "🔄 Restarting auto-sync..." -ForegroundColor Yellow
    Stop-AutoSync
    Start-Sleep 2
    Start-AutoSync
}

function Show-Status {
    $status = Get-TaskStatus
    
    Write-Host "📊 AUTO-SYNC STATUS:" -ForegroundColor Cyan
    Write-Host "Task Name: $taskName" -ForegroundColor White
    
    if ($status.Exists) {
        $stateColor = switch ($status.State) {
            "Running" { "Green" }
            "Ready" { "Yellow" }
            default { "Red" }
        }
        
        Write-Host "Status: $($status.State)" -ForegroundColor $stateColor
        
        if ($status.LastRunTime) {
            Write-Host "Last Run: $($status.LastRunTime)" -ForegroundColor White
        }
        
        if ($status.NextRunTime) {
            Write-Host "Next Run: $($status.NextRunTime)" -ForegroundColor White
        }
    } else {
        Write-Host "Status: Not Installed" -ForegroundColor Red
        Write-Host "Run install-bazarse-autosync.ps1 first!" -ForegroundColor Yellow
    }
    
    Write-Host ""
}

function Show-Logs {
    if (Test-Path $logFile) {
        Write-Host "📝 RECENT LOGS (Last 20 lines):" -ForegroundColor Cyan
        Write-Host "Log file: $logFile" -ForegroundColor Gray
        Write-Host "-" * 50 -ForegroundColor Gray
        
        Get-Content $logFile -Tail 20 | ForEach-Object {
            $color = "White"
            if ($_ -match "\[ERROR\]") { $color = "Red" }
            elseif ($_ -match "\[SUCCESS\]") { $color = "Green" }
            elseif ($_ -match "\[WARNING\]") { $color = "Yellow" }
            
            Write-Host $_ -ForegroundColor $color
        }
        
        Write-Host "-" * 50 -ForegroundColor Gray
        Write-Host ""
        Write-Host "💡 To view full logs: notepad `"$logFile`"" -ForegroundColor Cyan
    } else {
        Write-Host "📝 No log file found yet." -ForegroundColor Yellow
        Write-Host "Log will be created when auto-sync runs." -ForegroundColor Gray
    }
    Write-Host ""
}

function Test-AutoSync {
    Write-Host "🧪 TESTING AUTO-SYNC..." -ForegroundColor Cyan
    Write-Host ""
    
    # Check if project path exists
    if (Test-Path $projectPath) {
        Write-Host "✅ Project path exists: $projectPath" -ForegroundColor Green
    } else {
        Write-Host "❌ Project path not found: $projectPath" -ForegroundColor Red
        return
    }
    
    # Check if it's a git repository
    Set-Location $projectPath
    $gitStatus = git status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Git repository verified" -ForegroundColor Green
    } else {
        Write-Host "❌ Not a valid Git repository" -ForegroundColor Red
        return
    }
    
    # Check remote connection
    Write-Host "🌐 Testing remote connection..." -ForegroundColor Yellow
    $fetchResult = git fetch origin 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Remote connection successful" -ForegroundColor Green
    } else {
        Write-Host "❌ Remote connection failed: $fetchResult" -ForegroundColor Red
        return
    }
    
    # Check for updates
    $behind = git rev-list --count HEAD..origin/master 2>$null
    if ([int]$behind -gt 0) {
        Write-Host "📥 $behind commits available to pull" -ForegroundColor Yellow
    } else {
        Write-Host "✅ Repository is up to date" -ForegroundColor Green
    }
    
    # Check task status
    $status = Get-TaskStatus
    if ($status.Exists) {
        Write-Host "✅ Scheduled task exists and is $($status.State)" -ForegroundColor Green
    } else {
        Write-Host "❌ Scheduled task not found" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "🎯 Test completed!" -ForegroundColor Cyan
}

function Show-Help {
    Write-Host "🔧 AVAILABLE COMMANDS:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host ".\control-autosync.ps1 start    - Start auto-sync" -ForegroundColor White
    Write-Host ".\control-autosync.ps1 stop     - Stop auto-sync" -ForegroundColor White
    Write-Host ".\control-autosync.ps1 restart  - Restart auto-sync" -ForegroundColor White
    Write-Host ".\control-autosync.ps1 status   - Show current status" -ForegroundColor White
    Write-Host ".\control-autosync.ps1 logs     - Show recent logs" -ForegroundColor White
    Write-Host ".\control-autosync.ps1 test     - Test configuration" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 Examples:" -ForegroundColor Cyan
    Write-Host ".\control-autosync.ps1           # Show status (default)" -ForegroundColor Gray
    Write-Host ".\control-autosync.ps1 start     # Start the service" -ForegroundColor Gray
    Write-Host ".\control-autosync.ps1 logs      # View recent activity" -ForegroundColor Gray
    Write-Host ""
}

# Main execution
Show-Header

switch ($Action.ToLower()) {
    "start" { Start-AutoSync }
    "stop" { Stop-AutoSync }
    "restart" { Restart-AutoSync }
    "status" { Show-Status }
    "logs" { Show-Logs }
    "test" { Test-AutoSync }
    default { 
        Show-Status
        Show-Help
    }
}

if ($Action -ne "logs") {
    Write-Host "💡 Use '.\control-autosync.ps1 logs' to see recent activity" -ForegroundColor Cyan
    Write-Host "💡 Use '.\control-autosync.ps1 test' to verify setup" -ForegroundColor Cyan
}
