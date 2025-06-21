# 🔥 BAZARSE AUTO-SYNC SYSTEM

**Automatic Git synchronization for Bazarse project - Never manually pull again!**

## 🎯 What This Does

- **Automatically pulls** Git changes every 2 minutes
- **Runs in background** - no manual intervention needed
- **Starts with Windows** - always active
- **Smart notifications** when updates are pulled
- **Comprehensive logging** for troubleshooting
- **Desktop shortcuts** for manual control

## 🚀 Quick Setup (One-Time)

### Step 1: Run Installer
```powershell
# Right-click PowerShell and "Run as Administrator"
Set-Location "C:\Users\vinam\Desktop\bazar se\bazarse"
.\install-bazarse-autosync.ps1
```

### Step 2: Restart Computer
```
Restart your computer once to activate auto-sync
```

**That's it! Auto-sync is now permanent.** 🎉

## 🔧 Manual Controls

### Control Panel
```powershell
# Show status
.\control-autosync.ps1

# Start auto-sync
.\control-autosync.ps1 start

# Stop auto-sync
.\control-autosync.ps1 stop

# Restart auto-sync
.\control-autosync.ps1 restart

# View recent logs
.\control-autosync.ps1 logs

# Test configuration
.\control-autosync.ps1 test
```

### Desktop Shortcuts
- **Start Bazarse Auto-Sync.lnk** - Start manually
- **Stop Bazarse Auto-Sync.lnk** - Stop manually

## 📊 Monitoring

### Log File Location
```
C:\Users\vinam\Desktop\bazar se\bazarse\auto-sync.log
```

### What Gets Logged
- ✅ Successful pulls with commit count
- ❌ Error messages and troubleshooting info
- 📥 When new commits are detected
- 🔄 Sync status every 2 minutes

### Sample Log Output
```
[2024-01-15 14:30:15] [INFO] ✅ Repository is up to date
[2024-01-15 14:32:15] [WARNING] 📥 Found 3 new commits! Pulling changes...
[2024-01-15 14:32:18] [SUCCESS] ✅ Successfully pulled 3 commits!
[2024-01-15 14:32:18] [SUCCESS] 🎉 Bazarse updated at 14:32:18
```

## 🎯 How It Works

1. **Windows Task Scheduler** runs the PowerShell script at startup
2. **Script checks** for Git updates every 2 minutes
3. **Automatically pulls** when new commits are found
4. **Shows notification** when updates are applied
5. **Logs everything** for monitoring

## 🛠️ Troubleshooting

### Auto-sync not working?
```powershell
# Check status
.\control-autosync.ps1 status

# Test configuration
.\control-autosync.ps1 test

# View logs for errors
.\control-autosync.ps1 logs
```

### Common Issues

**❌ Task not found**
- Run installer again as Administrator

**❌ Git errors**
- Check internet connection
- Verify Git credentials
- Ensure repository is clean (no uncommitted changes)

**❌ Permission errors**
- Run PowerShell as Administrator
- Check execution policy: `Get-ExecutionPolicy`

### Manual Fix
```powershell
# Reset execution policy
Set-ExecutionPolicy RemoteSigned -Force

# Restart the task
.\control-autosync.ps1 restart
```

## 📋 System Requirements

- ✅ Windows 10/11
- ✅ PowerShell 5.0+
- ✅ Git installed and configured
- ✅ Administrator access (one-time setup)

## 🔒 Security

- **Runs with user privileges** (not system-level)
- **Only pulls changes** (never pushes automatically)
- **Logs all activity** for transparency
- **Can be stopped anytime** with desktop shortcuts

## 🎉 Benefits

### Before Auto-Sync
```bash
# Manual process every time
git pull origin master
flutter run
```

### After Auto-Sync
```
✅ Changes automatically appear
✅ Always up-to-date code
✅ No manual intervention
✅ Notifications when updated
```

## 📞 Support Commands

### Quick Status Check
```powershell
.\control-autosync.ps1
```

### View Recent Activity
```powershell
.\control-autosync.ps1 logs
```

### Emergency Stop
```powershell
.\control-autosync.ps1 stop
```

### Full System Test
```powershell
.\control-autosync.ps1 test
```

## 🔄 Uninstall (if needed)

```powershell
# Remove scheduled task
Unregister-ScheduledTask -TaskName "BazarseAutoSync" -Confirm:$false

# Delete desktop shortcuts
Remove-Item "$env:USERPROFILE\Desktop\*Bazarse Auto-Sync*.lnk"

# Delete log file
Remove-Item "C:\Users\vinam\Desktop\bazar se\bazarse\auto-sync.log"
```

---

## 🎯 Summary

**One-time setup = Permanent auto-sync!**

1. ✅ Run installer as Administrator
2. ✅ Restart computer
3. ✅ Enjoy automatic Git synchronization forever!

**No more manual `git pull` commands needed!** 🚀
