# 🔥 SIMPLE BAZARSE AUTO-SYNC 🔥
# Working auto-sync script without complex features

$ProjectPath = "C:\Users\vinam\Desktop\bazar se\bazarse"
$logFile = Join-Path $ProjectPath "auto-sync.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Host $logEntry
    try {
        Add-Content -Path $logFile -Value $logEntry
    } catch {
        # Silent fail
    }
}

Write-Log "🔥 Bazarse Auto-Sync Started!"
Write-Log "📁 Project Path: $ProjectPath"

# Check if project exists
if (-not (Test-Path $ProjectPath)) {
    Write-Log "❌ Project path not found: $ProjectPath"
    exit 1
}

# Change to project directory
Set-Location $ProjectPath

# Check if Git repository
try {
    $gitStatus = git status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Log "❌ Not a Git repository"
        exit 1
    }
    Write-Log "✅ Git repository verified"
} catch {
    Write-Log "❌ Git not available"
    exit 1
}

# Main sync loop
while ($true) {
    try {
        Write-Log "🔍 Checking for updates..."
        
        # Fetch latest from remote
        git fetch origin 2>$null
        
        # Check how many commits we're behind
        $behind = git rev-list --count HEAD..origin/master 2>$null
        $commitsCount = 0
        
        if ($behind -and [int]::TryParse($behind, [ref]$commitsCount)) {
            if ($commitsCount -gt 0) {
                Write-Log "📥 Found $commitsCount new commits! Pulling changes..."
                
                # Pull the changes
                $pullResult = git pull origin master 2>&1
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Log "✅ Successfully pulled $commitsCount commits!"
                    Write-Log "🎉 Bazarse updated at $(Get-Date -Format 'HH:mm:ss')"
                    
                    # Show notification
                    try {
                        Add-Type -AssemblyName System.Windows.Forms
                        [System.Windows.Forms.MessageBox]::Show("Bazarse updated with $commitsCount new commits!", "Auto-Sync Success", "OK", "Information") | Out-Null
                    } catch {
                        Write-Log "📢 Notification: Bazarse updated!"
                    }
                } else {
                    Write-Log "❌ Git pull failed: $pullResult"
                }
            } else {
                Write-Log "✅ Repository is up to date"
            }
        } else {
            Write-Log "⚠️ Could not check commit count"
        }
        
        # Wait 2 minutes before next check
        Write-Log "⏰ Waiting 2 minutes for next check..."
        Start-Sleep 120
        
    } catch {
        Write-Log "❌ Error in sync loop: $($_.Exception.Message)"
        Write-Log "🔄 Retrying in 1 minute..."
        Start-Sleep 60
    }
}
