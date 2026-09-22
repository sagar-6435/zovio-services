@echo off
echo Generating Flutter icons and splash screens...
echo.

echo Step 1: Installing dependencies...
flutter pub get

echo.
echo Step 2: Generating app icons for all platforms...
dart run flutter_launcher_icons

echo.
echo Step 3: Generating splash screens...
dart run flutter_native_splash:create

echo.
echo Done! Your icons and splash screens have been generated.
echo.
echo Next steps:
echo - Copy your logo image to: assets/images/favicon.png
echo - Copy your logo image to: assets/images/splash_logo.png
echo - Run this script again to regenerate with your images
echo.
pause
