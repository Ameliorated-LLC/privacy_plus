cd /d "%~dp0"

for /f "usebackq delims=" %%A in (`type "playbook.conf" ^| findstr /c:"<Version>"`) do (
	set "versionXml=%%A"
)

del /q /f "Privacy+ v%versionXml:~10,-10%.apbx"
7z a "Privacy+ v%versionXml:~10,-10%.apbx" playbook.conf Executables Configuration Images -pmalte
if %ERRORLEVEL% NEQ 0 (
	pause
)