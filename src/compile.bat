cd /d "%~dp0"

for /f "usebackq delims=" %%A in (`type "playbook.conf" ^| findstr /c:"<Version>"`) do (
	set "versionXml=%%A"
)

del /q /f "Privacy+ v%versionXml:~10,-10%.apbx"
7z a "Privacy+ v%versionXml:~10,-10%.apbx" playbook.conf Executables Configuration Images -pmalte
rem 7z a -spf -y -mx1 -pmalte -tzip "Privacy+ v%versionXml:~10,-10%.apbx" playbook.conf Executables Configuration Images

if %ERRORLEVEL% NEQ 0 (
	pause
)