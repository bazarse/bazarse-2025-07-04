@echo off
echo 🚀 Copying Bazarse Location System Files...
echo.

REM Set your local project path
set LOCAL_PATH=C:\Users\vinam\Desktop\bazar se\bazarse

echo 📁 Target Directory: %LOCAL_PATH%
echo.

REM Check if directory exists
if not exist "%LOCAL_PATH%" (
    echo ❌ Error: Directory not found!
    echo Please update LOCAL_PATH in this script to your correct project path.
    pause
    exit /b 1
)

echo 📋 Creating new directories if needed...
if not exist "%LOCAL_PATH%\lib\models" mkdir "%LOCAL_PATH%\lib\models"
if not exist "%LOCAL_PATH%\lib\services" mkdir "%LOCAL_PATH%\lib\services"
if not exist "%LOCAL_PATH%\lib\widgets" mkdir "%LOCAL_PATH%\lib\widgets"
if not exist "%LOCAL_PATH%\lib\screens" mkdir "%LOCAL_PATH%\lib\screens"

echo.
echo 📝 Files to copy manually:
echo.
echo 🆕 NEW FILES:
echo   - lib/models/saved_location_model.dart
echo   - lib/services/enhanced_location_service.dart
echo   - lib/widgets/location_map_widget.dart
echo   - lib/widgets/save_location_dialog.dart
echo   - lib/screens/add_location_screen.dart
echo.
echo ✏️ MODIFIED FILES:
echo   - pubspec.yaml (add dependencies)
echo   - lib/main.dart (add providers)
echo   - lib/screens/home_screen.dart (update location handler)
echo   - lib/widgets/universal_location_modal.dart (add features)
echo.
echo 📖 Please refer to update_local_files.md for detailed instructions.
echo.
echo 🔧 After copying files, run:
echo   flutter pub get
echo   flutter run
echo.
pause
