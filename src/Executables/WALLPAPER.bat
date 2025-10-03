
NSudoLC -U:T -P:E -M:S -Priority:RealTime -UseCurrentConsole -Wait icacls "%WINDIR%\Resources\Themes\aero.theme" /reset /t
PowerShell -NoP -C "$Content = (Get-Content '%WINDIR%\Resources\Themes\aero.theme'); $Content = $Content -replace 'Wallpaper=%%SystemRoot%%.*', 'Wallpaper=%%SystemRoot%%\web\wallpaper\Windows\ame_wallpaper_4K.bmp'; $Content = $Content -replace 'SystemMode=.*', 'SystemMode=Dark'; $Content -replace 'AppMode=.*', 'AppMode=Light' | Set-Content '%WINDIR%\Resources\Themes\aero.theme'"

@echo OFF

if exist "ame_wallpaper_4K.bmp" (
	echo move /y "ame_wallpaper_4K.bmp" "%WINDIR%\Web\Wallpaper\Windows"
	move /y "ame_wallpaper_4K.bmp" "%WINDIR%\Web\Wallpaper\Windows"
	echo icacls "%WINDIR%\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" /reset
	icacls "%WINDIR%\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" /reset
)

set "RunEC=10"
for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
	if "%%A"=="AME_UserHive_Default" (
		call :WALLRUN "%%A" "%SYSTEMDRIVE%\Users\Default"
			IF errorlevel 5 set "RunEC=5"
			IF errorlevel 4 set "RunEC=4"
			IF errorlevel 3 set "RunEC=3"
			IF errorlevel 2 set "RunEC=2"
			IF errorlevel 1 set "RunEC=1"
			IF errorlevel 0 set "RunEC=0"
	) else (
		for /f "usebackq tokens=2* delims= " %%B in (`reg query "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "AppData" 2^>^&1 ^| findstr /R /X /C:".*AppData[ ]*REG_SZ[ ].*"`) do (
			call :WALLRUN "%%A" "%%C"
				IF errorlevel 5 set "RunEC=5"
				IF errorlevel 4 set "RunEC=4"
				IF errorlevel 3 set "RunEC=3"
				IF errorlevel 2 set "RunEC=2"
				IF errorlevel 1 set "RunEC=1"
				IF errorlevel 0 set "RunEC=0"
		)
	)
)

exit /b %RunEC%

:WALLRUN
reg add "HKEY_USERS\%~1\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSpotlightCollectionOnDesktop /t REG_DWORD /d 1 /f

if not exist "%WINDIR%\Web\Wallpaper\Windows" echo mkdir "%WINDIR%\Web\Wallpaper\Windows" & mkdir "%WINDIR%\Web\Wallpaper\Windows"
if exist "%~2\Microsoft\Windows\Themes\Transcoded_000" set "wallChanged=true" & goto lockScreen

reg query "HKEY_USERS\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings" /v EnabledState | findstr /c:"0x1" > NUL 2>&1
if %errorlevel% NEQ 0 (
	echo PowerShell -NoP -C "Add-Type -AssemblyName System.Drawing; $img = New-Object System.Drawing.Bitmap '%~2\Microsoft\Windows\Themes\TranscodedWallpaper'; if ($img.Flags -ne 77840) {exit 1}; if ($img.HorizontalResolution -ne 96) {exit 1}; if ($img.VerticalResolution -ne 96) {exit 1}; if ($img.PropertyIdList -notcontains 40961) {exit 1}; if ($img.PropertyIdList -notcontains 20624) {exit 1}; if ($img.PropertyIdList -notcontains 20625) {exit 1}"
	PowerShell -NoP -C "Add-Type -AssemblyName System.Drawing; $img = New-Object System.Drawing.Bitmap '%~2\Microsoft\Windows\Themes\TranscodedWallpaper'; if ($img.Flags -ne 77840) {exit 1}; if ($img.HorizontalResolution -ne 96) {exit 1}; if ($img.VerticalResolution -ne 96) {exit 1}; if ($img.PropertyIdList -notcontains 40961) {exit 1}; if ($img.PropertyIdList -notcontains 20624) {exit 1}; if ($img.PropertyIdList -notcontains 20625) {exit 1}"
		if errorlevel 1 (
		    reg query "HKEY_USERS\%~1\Control Panel\Desktop" /v WallPaper | findstr /i /c:"MicrosoftWindows.Client.CBS_cw5n1h2txyewy\DesktopSpotlight"
				if errorlevel 1 set "wallChanged=true" & goto lockScreen
		)
)
if exist "img0_*" (
	echo takeown /f "%WINDIR%\Web\4K\Wallpaper\Windows\*.jpg"
	takeown /f "%WINDIR%\Web\4K\Wallpaper\Windows\*.jpg"
	echo icacls "%WINDIR%\Web\4K\Wallpaper\Windows\*.jpg" /reset
	icacls "%WINDIR%\Web\4K\Wallpaper\Windows\*.jpg" /reset
	echo move /y img0_*.jpg "%WINDIR%\Web\4K\Wallpaper\Windows"
	move /y img0_*.jpg "%WINDIR%\Web\4K\Wallpaper\Windows"
)

if exist "img0.jpg" (
	echo takeown /f "%WINDIR%\Web\Wallpaper\Windows\img0.jpg"
	takeown /f "%WINDIR%\Web\Wallpaper\Windows\img0.jpg"
	echo icacls "%WINDIR%\Web\Wallpaper\Windows\img0.jpg" /reset
	icacls "%WINDIR%\Web\Wallpaper\Windows\img0.jpg" /reset
	echo copy /y "img0.jpg" "%WINDIR%\Web\Wallpaper\Windows\img0.jpg"
	copy /y "img0.jpg" "%WINDIR%\Web\Wallpaper\Windows\img0.jpg"
	echo takeown /f "%WINDIR%\Web\4K\Wallpaper\Windows\img0._1920x1200.jpg"
	takeown /f "%WINDIR%\Web\4K\Wallpaper\Windows\img0_1920x1200.jpg"
	echo icacls "%WINDIR%\Web\4K\Wallpaper\Windows\img0_1920x1200.jpg" /reset
	icacls "%WINDIR%\Web\4K\Wallpaper\Windows\img0_1920x1200.jpg" /reset
	echo copy /y "img0.jpg" "%WINDIR%\Web\4K\Wallpaper\Windows\img0_1920x1200.jpg"
	copy /y "img0.jpg" "%WINDIR%\Web\4K\Wallpaper\Windows\img0_1920x1200.jpg"
	echo takeown /f "%WINDIR%\Web\Wallpaper\Spotlight\img14.jpg"
	takeown /f "%WINDIR%\Web\Wallpaper\Spotlight\img14.jpg"
	echo icacls "%WINDIR%\Web\Wallpaper\Spotlight\img14.jpg" /reset
	icacls "%WINDIR%\Web\Wallpaper\Spotlight\img14.jpg" /reset
	echo copy /y "img0.jpg" "%WINDIR%\Web\Wallpaper\Spotlight\img14.jpg"
	copy /y "img0.jpg" "%WINDIR%\Web\Wallpaper\Spotlight\img14.jpg"
)

if not exist "%WINDIR%\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" set "wallFail=true" & goto lockScreen

echo reg add "HKEY_USERS\%~1\Control Panel\Desktop" /v WallPaper /t REG_SZ /d "%WINDIR%\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" /f
reg add "HKEY_USERS\%~1\Control Panel\Desktop" /v WallPaper /t REG_SZ /d "%WINDIR%\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" /f
	if %errorlevel% NEQ 0 set "wallFail=true" & goto lockScreen
reg add "HKEY_USERS\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings" /v EnabledState /t REG_DWORD /d 0 /f
reg add "HKEY_USERS\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v BackgroundType /t REG_DWORD /d 0 /f
reg add "HKEY_USERS\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v CurrentWallpaperPath /t REG_SZ /d "%WINDIR%\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" /f

del /q /f "%~2\Microsoft\Windows\Themes\TranscodedWallpaper"
rmdir /q /s "%~2\Microsoft\Windows\Themes\CachedFiles"

:lockScreen

reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\%~1" /v "RotatingLockScreen*" > NUL 2>&1
	if %errorlevel% NEQ 0 (
		echo "%~1" | findstr /c:"S-" > NUL
			if not errorlevel 1 (
				echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\%~1" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f
				reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\%~1" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f
			)
		echo reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f
		reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f

		if exist "img100.jpg" (
			echo takeown /f "%WINDIR%\Web\Screen\img100.jpg"
			takeown /f "%WINDIR%\Web\Screen\img100.jpg"
			echo icacls "%WINDIR%\Web\Screen\img100.jpg" /reset
			icacls "%WINDIR%\Web\Screen\img100.jpg" /reset
			echo copy "img100.jpg" "%WINDIR%\Web\Screen\img100.jpg" /Y
			copy "img100.jpg" "%WINDIR%\Web\Screen\img100.jpg" /Y
		)

		if exist "img103.png" (
			echo takeown /f "%WINDIR%\Web\Screen\img103.png"
			takeown /f "%WINDIR%\Web\Screen\img103.png"
			echo icacls "%WINDIR%\Web\Screen\img103.png" /reset
			icacls "%WINDIR%\Web\Screen\img103.png" /reset
			echo copy "img103.png" "%WINDIR%\Web\Screen\img103.png" /Y
			copy "img103.png" "%WINDIR%\Web\Screen\img103.png" /Y
		)

		if exist "img0.jpg" (
			echo takeown /f "%WINDIR%\Web\Wallpaper\Windows\img0.jpg"
			takeown /f "%WINDIR%\Web\Wallpaper\Windows\img0.jpg"
			echo icacls "%WINDIR%\Web\Wallpaper\Windows\img0.jpg" /reset
			icacls "%WINDIR%\Web\Wallpaper\Windows\img0.jpg" /reset
			echo copy "img0.jpg" "%WINDIR%\Web\Wallpaper\Windows\img0.jpg" /Y
			copy "img0.jpg" "%WINDIR%\Web\Wallpaper\Windows\img0.jpg" /Y
		)

		REM Clear cache
		echo takeown /R /D Y /F "%PROGRAMDATA%\Microsoft\Windows\SystemData"
		takeown /R /D Y /F "%PROGRAMDATA%\Microsoft\Windows\SystemData"
		echo icacls "%PROGRAMDATA%\Microsoft\Windows\SystemData" /reset /t
		icacls "%PROGRAMDATA%\Microsoft\Windows\SystemData" /reset /t
		for /d %%A in ("%PROGRAMDATA%\Microsoft\Windows\SystemData\*") do (
			for /d %%B in ("%%A\ReadOnly\LockScreen_*") do echo rmdir /q /s "%%B" & rmdir /q /s "%%B"
		)
		if "%wallChanged%"=="true" exit /b 1
		if "%wallFail%"=="true" exit /b 4
	) else (
		if "%wallChanged%"=="true" exit /b 3
		if "%wallFail%"=="true" exit /b 5
		exit /b 2
	)

exit /b 0