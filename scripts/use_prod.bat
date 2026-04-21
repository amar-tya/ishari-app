@echo off
echo [env] Switching to PRODUCTION environment...
copy /Y env\prod.env env\current.env >nul
if errorlevel 1 (
    echo [error] env\prod.env not found. Copy from env\prod.env.example and fill in values.
    exit /b 1
)
echo [env] Generating env.g.dart...
fvm dart run build_runner build --delete-conflicting-outputs
echo [env] Done! Run "flutter build apk --release" to build.
