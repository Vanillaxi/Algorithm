@echo off
echo ================================
echo       Git Auto Sync Start
echo ================================

echo.
echo [1/4] Pull latest changes...
git pull origin main
if %errorlevel% neq 0 (
    echo Pull failed!
    pause
    exit /b
)

echo.
echo [2/4] Add files...
git add .

echo.
echo [3/4] Commit changes...
set msg=update notes %date% %time%
git commit -m "%msg%"
if %errorlevel% neq 0 (
    echo Nothing to commit.
)

echo.
echo [4/4] Push to GitHub...
git push origin main
if %errorlevel% neq 0 (
    echo Push failed!
    pause
    exit /b
)

echo.
echo ================================
echo      Sync Finished Successfully
echo ================================
pause