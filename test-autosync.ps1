# 🔥 BAZARSE AUTO-SYNC TESTER 🔥
# Test if auto-sync is working

Write-Host "🔥 BAZARSE AUTO-SYNC TESTER" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

$ProjectPath = "C:\Users\vinam\Desktop\bazar se\bazarse"
$logFile = Join-Path $ProjectPath "auto-sync.log"
$taskName = "BazarseAutoSync"

# Test 1: Check project path
Write-Host "📁 Test 1: Project Path" -ForegroundColor Yellow
if (Test-Path $ProjectPath) {
    Write-Host "✅ Project path exists: $ProjectPath" -ForegroundColor Green
} else {
    Write-Host "❌ Project path not found: $ProjectPath" -ForegroundColor Red
    exit
}

# Test 2: Check if Git repository
Write-Host "📁 Test 2: Git Repository" -ForegroundColor Yellow
Set-Location $ProjectPath
try {
    $gitStatus = git status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Git repository verified" -ForegroundColor Green
    } else {
        Write-Host "❌ Not a Git repository" -ForegroundColor Red
        exit
    }
} catch {
    Write-Host "❌ Git not available" -ForegroundColor Red
    exit
}

# Test 3: Check remote connection
Write-Host "🌐 Test 3: Remote Connection" -ForegroundColor Yellow
try {
    git fetch origin 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Remote connection successful" -ForegroundColor Green
    } else {
        Write-Host "❌ Remote connection failed" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Remote connection error" -ForegroundColor Red
}

# Test 4: Check for updates
Write-Host "📥 Test 4: Check Updates" -ForegroundColor Yellow
try {
    $behind = git rev-list --count HEAD..origin/master 2>$null
    if ($behind -and [int]::TryParse($behind, [ref]$null)) {
        if ([int]$behind -gt 0) {
            Write-Host "📥 $behind commits available to pull" -ForegroundColor Yellow
        } else {
            Write-Host "✅ Repository is up to date" -ForegroundColor Green
        }
    } else {
        Write-Host "⚠️ Could not check commit count" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Error checking updates" -ForegroundColor Red
}

# Test 5: Check scheduled task
Write-Host "📅 Test 5: Scheduled Task" -ForegroundColor Yellow
try {
    $task = Get-ScheduledTask -TaskName $taskName -ErrorAction Stop
    Write-Host "✅ Task exists: $($task.TaskName)" -ForegroundColor Green
    Write-Host "   State: $($task.State)" -ForegroundColor White
    
    $taskInfo = Get-ScheduledTaskInfo -TaskName $taskName
    if ($taskInfo.LastRunTime -and $taskInfo.LastRunTime -gt (Get-Date "1999-12-31")) {
        Write-Host "   Last Run: $($taskInfo.LastRunTime)" -ForegroundColor White
    } else {
        Write-Host "   Last Run: Never" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Scheduled task not found" -ForegroundColor Red
}

# Test 6: Check auto-sync script
Write-Host "📝 Test 6: Auto-Sync Script" -ForegroundColor Yellow
$scriptPath = Join-Path $ProjectPath "simple-auto-sync.ps1"
if (Test-Path $scriptPath) {
    Write-Host "✅ Auto-sync script exists" -ForegroundColor Green
} else {
    Write-Host "❌ Auto-sync script not found: $scriptPath" -ForegroundColor Red
}

# Test 7: Check log file
Write-Host "📊 Test 7: Log File" -ForegroundColor Yellow
if (Test-Path $logFile) {
    Write-Host "✅ Log file exists" -ForegroundColor Green
    Write-Host "📝 Recent log entries:" -ForegroundColor Cyan
    try {
        Get-Content $logFile -Tail 5 | ForEach-Object {
            Write-Host "   $_" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   Could not read log file" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️ Log file not created yet" -ForegroundColor Yellow
}

# Test 8: Manual sync test
Write-Host "🧪 Test 8: Manual Sync Test" -ForegroundColor Yellow
Write-Host "Running a quick sync test..." -ForegroundColor White
try {
    git fetch origin 2>$null
    $behind = git rev-list --count HEAD..origin/master 2>$null
    
    if ($behind -and [int]$behind -gt 0) {
        Write-Host "📥 Would pull $behind commits" -ForegroundColor Yellow
        Write-Host "   (Not actually pulling in test mode)" -ForegroundColor Gray
    } else {
        Write-Host "✅ Sync test successful - repository up to date" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Sync test failed" -ForegroundColor Red
}

# Summary
Write-Host ""
Write-Host "📋 TEST SUMMARY" -ForegroundColor Cyan
Write-Host "===============" -ForegroundColor Cyan

# Quick commands
Write-Host ""
Write-Host "🔧 QUICK COMMANDS:" -ForegroundColor Cyan
Write-Host "Start task manually: Start-ScheduledTask -TaskName '$taskName'" -ForegroundColor White
Write-Host "Stop task: Stop-ScheduledTask -TaskName '$taskName'" -ForegroundColor White
Write-Host "Check task status: Get-ScheduledTask -TaskName '$taskName'" -ForegroundColor White
Write-Host "View logs: Get-Content '$logFile' -Tail 10" -ForegroundColor White
Write-Host "Test sync: cd '$ProjectPath'; git fetch origin; git status" -ForegroundColor White
Write-Host ""

Write-Host "🎯 If everything shows ✅, auto-sync should be working!" -ForegroundColor Green
Write-Host "🎯 If you see ❌, run setup-autosync.ps1 again" -ForegroundColor Yellow
