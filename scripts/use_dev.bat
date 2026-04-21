@echo off
echo [env] Switching to DEVELOPMENT environment...
copy /Y env\dev.env env\current.env >nul
if errorlevel 1 (
    echo [error] env\dev.env not found. Copy from env\dev.env.example and fill in values.
    exit /b 1
)
echo [env] Generating env.g.dart...
fvm dart run build_runner build --delete-conflicting-outputs
echo [env] Done! Run "flutter run" to start the app.
