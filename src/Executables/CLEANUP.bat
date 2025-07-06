copy /y "AssociationsFirefox.dll" "%SYSTEMROOT%\System32\OEMDefaultAssociations.dll"

for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (


	reg query "HKU\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
		if not errorlevel 1 (
			:: Clear W11 start menu pinned items, necessary on newer Windows versions.
			reg delete "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\Start" /v "Config" /f

			for /f "usebackq tokens=3* delims= " %%B in (`reg query "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Local AppData" 2^>^&1 ^| findstr /R /X /C:".*Local AppData[ ]*REG_SZ[ ].*"`) do (
				:: Clear W11 start menu pinned items
				for /f "usebackq delims=" %%D in (`dir /b "%%C\Packages" /a:d ^| findstr /c:"Microsoft.Windows.StartMenuExperienceHost"`) do (
					for /f "usebackq delims=" %%E in (`dir /b "%%C\Packages\%%D\LocalState" /a:-d ^| findstr /R /c:"start.\.bin" /c:"start\.bin"`) do (
						echo del /q /f "%%C\Packages\%%D\LocalState\%%E"
						del /q /f "%%C\Packages\%%D\LocalState\%%E"
					)
				)

				rmdir /q /s "%%C\Microsoft\Windows\Notifications"
			)

			for /f "usebackq tokens=2* delims= " %%B in (`reg query "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "AppData" 2^>^&1 ^| findstr /R /X /C:".*AppData[ ]*REG_SZ[ ].*"`) do (
				echo del "%%C\Microsoft\Windows\Start Menu\Programs\Accessories\Internet Explorer.lnk" /q /f
				del "%%C\Microsoft\Windows\Start Menu\Programs\Accessories\Internet Explorer.lnk" /q /f
				echo del "%%C\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk" /q /f
				del "%%C\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk" /q /f
				echo del "%%C\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk" /q /f
				del "%%C\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk" /q /f
			)
		)
)