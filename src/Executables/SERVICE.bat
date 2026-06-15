@echo OFF

REM reg query "HKLM\System\CurrentControlSet\Services\CryptSvc" /v "LaunchProtected" > NUL 2>&1
REM if not errorlevel 1 (
REM     echo "LaunchProtected value detected."
REM     exit /b 1
REM )

copy /y "%SystemRoot%\System32\svchost.exe" "%SystemRoot%\System32\amehost.exe"
if not exist "%SystemRoot%\System32\amehost.exe" (
    echo "Failed to copy amehost.exe file."
    exit /b 1
)

REM Communicates with login.live.com even when login is not initiated
reg add "HKLM\System\CurrentControlSet\Services\wlidsvc" /v "ImagePath" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\amehost.exe -k netsvcs -p" /f
REM Occasionally communicates with Microsoft servers
reg add "HKLM\System\CurrentControlSet\Services\CryptSvc" /v "ImagePath" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\amehost.exe -k NetworkService -p" /f
REM Communicates with inference-app-gateway.eastus2.cloudapp.azure.com upon new user creation
reg add "HKLM\System\CurrentControlSet\Services\lfsvc" /v "ImagePath" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\amehost.exe -k netsvcs -p" /f