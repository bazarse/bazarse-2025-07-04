# 🔥 BAZARSE AUTO-SYNC - VINU BHAISAHAB KA PERMANENT SOLUTION 🔥
# This script automatically pulls Git changes every 2 minutes

param(
    [string]$ProjectPath = "C:\Users\vinam\Desktop\bazar se\bazarse",
    [int]$CheckInterval = 120  # 2 minutes
)

# Setup logging
$logFile = Join-Path $ProjectPath "auto-sync.log"
$maxLogSize = 5MB

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"

    # Console output
    switch ($Level) {
        "ERROR" { Write-Host $logEntry -ForegroundColor Red }
        "SUCCESS" { Write-Host $logEntry -ForegroundColor Green }
        "WARNING" { Write-Host $logEntry -ForegroundColor Yellow }
        default { Write-Host $logEntry -ForegroundColor Cyan }
    }

    # File logging
    try {
        # Rotate log if too large
        if ((Test-Path $logFile) -and (Get-Item $logFile).Length -gt $maxLogSize) {
            Move-Item $logFile "$logFile.old" -Force
        }

        Add-Content -Path $logFile -Value $logEntry -ErrorAction SilentlyContinue
    } catch {
        # Silent fail for logging
    }
}

function Test-GitRepository {
    try {
        Set-Location $ProjectPath
        $gitStatus = git status 2>&1
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

function Get-RemoteCommitsCount {
    try {
        # Fetch latest from remote
        git fetch origin master 2>$null
        
        # Count commits behind
        $behind = git rev-list --count HEAD..origin/master 2>$null
        return [int]$behind
    } catch {
        return 0
    }
}

function Sync-Repository {
    try {
        Write-Log "🔄 Starting sync process..." "INFO"
        
        # Check if we're in a git repository
        if (-not (Test-GitRepository)) {
            Write-Log "❌ Not a valid Git repository: $ProjectPath" "ERROR"
            return $false
        }
        
        # Get commits count
        $commitsCount = Get-RemoteCommitsCount
        
        if ($commitsCount -gt 0) {
            Write-Log "📥 Found $commitsCount new commits! Pulling changes..." "WARNING"
            
            # Pull changes
            $pullResult = git pull origin master 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Log "✅ Successfully pulled $commitsCount commits!" "SUCCESS"
                Write-Log "🎉 Bazarse updated at $(Get-Date -Format 'HH:mm:ss')" "SUCCESS"
                
                # Optional: Run flutter pub get after successful pull
                try {
                    if (Get-Command flutter -ErrorAction SilentlyContinue) {
                        Write-Log "📦 Running flutter pub get..." "INFO"
                        flutter pub get 2>$null
                        if ($LASTEXITCODE -eq 0) {
                            Write-Log "✅ Flutter dependencies updated!" "SUCCESS"
                        }
                    }
                } catch {
                    Write-Log "⚠️ Flutter pub get skipped" "WARNING"
                }
                
                # Show desktop notification
                Show-Notification "Bazarse Updated!" "Successfully pulled $commitsCount new commits"
                
                return $true
            } else {
                Write-Log "❌ Git pull failed: $pullResult" "ERROR"
                return $false
            }
        } else {
            Write-Log "✅ Repository is up to date" "INFO"
            return $true
        }
    } catch {
        Write-Log "❌ Sync error: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Show-Notification {
    param([string]$Title, [string]$Message)
    
    try {
        # Create notification using Windows Toast
        $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
        $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
        $template.SelectSingleNode("//text[@id='1']").InnerText = $Title
        $template.SelectSingleNode("//text[@id='2']").InnerText = $Message
        $toast = [Windows.UI.Notifications.ToastNotification]::new($template)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Bazarse Auto-Sync").Show($toast)
    } catch {
        # Fallback to simple popup
        try {
            Add-Type -AssemblyName System.Windows.Forms
            [System.Windows.Forms.MessageBox]::Show($Message, $Title, "OK", "Information") | Out-Null
        } catch {
            # Silent fail for notifications
        }
    }
}

function Start-AutoSync {
    Write-Log "🔥 Bazarse Auto-Sync Started!" "SUCCESS"
    Write-Log "📁 Project Path: $ProjectPath" "INFO"
    Write-Log "⏰ Check Interval: $CheckInterval seconds" "INFO"
    Write-Log "📝 Log File: $logFile" "INFO"
    
    # Initial sync
    Sync-Repository | Out-Null
    
    # Main loop
    while ($true) {
        try {
            Start-Sleep $CheckInterval
            Sync-Repository | Out-Null
        } catch {
            Write-Log "❌ Main loop error: $($_.Exception.Message)" "ERROR"
            Start-Sleep 60  # Wait 1 minute before retrying
        }
    }
}

# Handle Ctrl+C gracefully
$null = Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    Write-Log "🛑 Bazarse Auto-Sync stopped by user" "WARNING"
}

# Start the auto-sync process
Start-AutoSync
