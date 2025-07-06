cd Executables

@if exist "%SYSTEMDRIVE%\Windows\StartMenuLayout.xml" echo del /q /f "%SYSTEMDRIVE%\Windows\StartMenuLayout.xml" & del /q /f "%SYSTEMDRIVE%\Windows\StartMenuLayout.xml"

copy /y "Layout.xml" "%SYSTEMDRIVE%\Windows\StartMenuLayout.xml"
copy /y "LayoutTaskbar.xml" "%SYSTEMDRIVE%\Windows\TaskbarLayout.xml"

@echo OFF
for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
	REM If the "Volatile Environment" key exists, that means it is a proper user. Built in accounts/SIDs don't have this key.
	reg query "HKEY_USERS\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
		if not errorlevel 1 (
			for /f "usebackq tokens=3* delims= " %%B in (`reg query "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Local AppData" 2^>^&1 ^| findstr /R /X /C:".*Local AppData[ ]*REG_SZ[ ].*"`) do (
				echo copy /y "LayoutUser.xml" "%%C\Microsoft\Windows\Shell\LayoutModification.xml"
				copy /y "LayoutUser.xml" "%%C\Microsoft\Windows\Shell\LayoutModification.xml"
			)
			echo reg add "HKU\%%A\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f
			reg add "HKU\%%A\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f
			echo reg add "HKU\%%A\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d 0 /f
			reg add "HKU\%%A\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d 0 /f
			echo reg add "HKU\%%A\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_SZ /d "C:\Windows\StartMenuLayout.xml" /f
			reg add "HKU\%%A\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_SZ /d "C:\Windows\StartMenuLayout.xml" /f
			for /f "usebackq delims=" %%C in (`reg query "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" ^| findstr /c:"start.tilegrid"`) do (
				echo reg delete "%%C" /f
				reg delete "%%C" /f
			)
		)
)


@echo ON

copy /y "LayoutUser.xml" "%SYSTEMDRIVE%\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"

REM Note: Deprecated on newer versions of Windows 11
PowerShell -NoP -C "Import-StartLayout -LayoutPath '%SYSTEMDRIVE%\Windows\StartMenuLayout.xml' -MountPath $env:SystemDrive\\"

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_SZ /d "%SYSTEMDRIVE%\Windows\StartMenuLayout.xml" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "LayoutXMLPath" /t REG_SZ /d "%SYSTEMDRIVE%\Windows\TaskbarLayout.xml" /f