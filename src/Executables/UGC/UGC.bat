@echo off

mkdir "%PROGRAMFILES%\UngoogledChromium"

copy /y "UGC\chrlauncher.ini" "%PROGRAMFILES%\UngoogledChromium"
copy /y "UGC\chrlauncher.exe" "%PROGRAMFILES%\UngoogledChromium"
copy /y "UGC\chrome.exe" "%PROGRAMFILES%\UngoogledChromium"
copy /y "UGC\ugc_uninstaller.exe" "%PROGRAMFILES%\UngoogledChromium\Ungoogled Uninstaller.exe"

if exist "ugc.7z" (
	7za.exe x "ugc.7z" -o"%PROGRAMFILES%\UngoogledChromium" -y
	for /f "usebackq delims=" %%A in (`dir /b /a:d "%PROGRAMFILES%\UngoogledChromium" ^| findstr /c:"chromium-"`) do (
		echo move /y "%PROGRAMFILES%\UngoogledChromium\%%A" "%PROGRAMFILES%\UngoogledChromium\bin"
		move /y "%PROGRAMFILES%\UngoogledChromium\%%A" "%PROGRAMFILES%\UngoogledChromium\bin"
	)
) else (
	PowerShell -NoP -C "Start-Process -FilePath '%PROGRAMFILES%\UngoogledChromium\chrlauncher.exe' -WindowStyle Hidden -Wait"
)
set "ICON=\"%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe\",0"

@echo on
reg add "HKLM\SOFTWARE\Classes\ChromiumHTML" /ve /t REG_SZ /d "Chromium HTML Document" /f
reg add "HKLM\SOFTWARE\Classes\ChromiumHTML" /v "AppUserModelId" /t REG_SZ /d "Chromium" /f
reg add "HKLM\SOFTWARE\Classes\ChromiumHTML\Application" /v "AppUserModelId" /t REG_SZ /d "Chromium" /f
reg add "HKLM\SOFTWARE\Classes\ChromiumHTML\Application" /v "ApplicationIcon" /t REG_SZ /d "%ICON%" /f
reg add "HKLM\SOFTWARE\Classes\ChromiumHTML\Application" /v "ApplicationName" /t REG_SZ /d "Ungoogled Chromium" /f
reg add "HKLM\SOFTWARE\Classes\ChromiumHTML\Application" /v "ApplicationDescription" /t REG_SZ /d "Ungoogled Chromium" /f
reg add "HKLM\SOFTWARE\Classes\ChromiumHTML\Application" /v "ApplicationCompany" /t REG_SZ /d "Chromium" /f
reg add "HKLM\SOFTWARE\Classes\ChromiumHTML\DefaultIcon" /ve /t REG_SZ /d "%ICON%" /f
reg add "HKLM\SOFTWARE\Classes\ChromiumHTML\shell\open\command" /ve /t REG_SZ /d """%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe"" --flag-switches-begin --no-default-browser-check --extension-mime-request-handling=always-prompt-for-install --flag-switches-end --single-argument %%1" /f

::reg add "HKLM\SOFTWARE\Policies\Chromium" /v "DefaultBrowserSettingEnabled" /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium" /ve /t REG_SZ /d "Chromium" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities" /v "ApplicationDescription" /t REG_SZ /d "Ungoogled Chromium" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities" /v "ApplicationIcon" /t REG_SZ /d "%ICON%" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities" /v "ApplicationName" /t REG_SZ /d "Ungoogled Chromium" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\FileAssociations" /v ".htm" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\FileAssociations" /v ".html" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\FileAssociations" /v ".pdf" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\FileAssociations" /v ".shtml" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\FileAssociations" /v ".svg" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\FileAssociations" /v ".xht" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\FileAssociations" /v ".xhtml" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\FileAssociations" /v ".webp" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\Startmenu" /v "StartMenuInternet" /t REG_SZ /d "Chromium" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "http" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "https" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "irc" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "mailto" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "mms" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "news" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "nntp" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "sms" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "smsto" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "snews" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "tel" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "urn" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities\URLAssociations" /v "webcal" /t REG_SZ /d "ChromiumHTML" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\DefaultIcon" /ve /t REG_SZ /d "%ICON%" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\InstallInfo" /v "HideIconsCommand" /t REG_SZ /d """%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe"" --hide-icons" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\InstallInfo" /v "ShowIconsCommand" /t REG_SZ /d """%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe"" --show-icons" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\InstallInfo" /v "IconsVisible" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Clients\StartMenuInternet\Chromium\shell\open\command" /ve /t REG_SZ /d """%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe""" /f

reg add "HKCR\.htm\OpenWithProgids" /v "Chromium" /f
reg add "HKCR\.html\OpenWithProgids" /v "Chromium" /f
reg add "HKCR\.pdf\OpenWithProgids" /v "Chromium" /f
reg add "HKCR\.shtml\OpenWithProgids" /v "Chromium" /f
reg add "HKCR\.svg\OpenWithProgids" /v "Chromium" /f
reg add "HKCR\.xht\OpenWithProgids" /v "Chromium" /f
reg add "HKCR\.xhtml\OpenWithProgids" /v "Chromium" /f
reg add "HKCR\.webp\OpenWithProgids" /v "Chromium" /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" /ve /t REG_SZ /d "%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" /v "Path" /t REG_SZ /d "%PROGRAMFILES%\UngoogledChromium\bin" /f

reg add "HKLM\SOFTWARE\RegisteredApplications" /v "Chromium" /d "SOFTWARE\Clients\StartMenuInternet\Chromium\Capabilities" /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\UGC-Uninstaller" /v "DisplayName" /t REG_SZ /d "Ungoogled Chromium" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\UGC-Uninstaller" /v "DisplayIcon" /t REG_SZ /d "%ICON%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\UGC-Uninstaller" /v "UninstallString" /t REG_SZ /d """%PROGRAMFILES%\UngoogledChromium\Ungoogled Uninstaller.exe""" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\UGC-Uninstaller" /v "QuietUninstallString" /t REG_SZ /d """%PROGRAMFILES%\UngoogledChromium\Ungoogled Uninstaller.exe""" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\UGC-Uninstaller" /v "NoRepair" /t REG_DWORD /d "1" /f

@echo off

for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
	REM If the "Volatile Environment" key exists, that means it is a proper user. Built in accounts/SIDs don't have this key.
	reg query "HKU\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
		if not errorlevel 1 (
			PowerShell -NoP -ExecutionPolicy Bypass -File assoc.ps1 "Placeholder" "%%A" ".html:ChromiumHTML" ".htm:ChromiumHTML" "Proto:https:ChromiumHTML" "Proto:http:ChromiumHTML"
	)
)

mkdir "%PROGRAMFILES%\UngoogledChromium\Extensions"

copy /y "UGC\Chromium.Web.Store.crx" "%PROGRAMFILES%\UngoogledChromium\Extensions"
copy /y "uBOLite.crx" "%PROGRAMFILES%\UngoogledChromium\Extensions"

copy /y "UGC\initial_preferences_ugc" "%PROGRAMFILES%\UngoogledChromium\bin\initial_preferences"

reg add "HKLM\SOFTWARE\WOW6432Node\Google" /f
reg add "HKLM\SOFTWARE\WOW6432Node\Google\Chrome" /f
reg add "HKLM\SOFTWARE\WOW6432Node\Google\Chrome\Extensions" /f

reg add "HKLM\SOFTWARE\WOW6432Node\Google\Chrome\Extensions\ocaahdebbfolfmndjeplogmgcagdmblk" /v "Path" /t REG_SZ /d "%PROGRAMFILES%\UngoogledChromium\Extensions\Chromium.Web.Store.crx" /f
reg add "HKLM\SOFTWARE\WOW6432Node\Google\Chrome\Extensions\ocaahdebbfolfmndjeplogmgcagdmblk" /v "Version" /t REG_SZ /d "1.5.4.3" /f

reg add "HKLM\SOFTWARE\WOW6432Node\Google\Chrome\Extensions\ecbibdikgcogagiklehmjddmlkipfjbc" /v "Path" /t REG_SZ /d "%PROGRAMFILES%\UngoogledChromium\Extensions\uBOLite.crx" /f
reg add "HKLM\SOFTWARE\WOW6432Node\Google\Chrome\Extensions\ecbibdikgcogagiklehmjddmlkipfjbc" /v "Version" /t REG_SZ /d "2025.512.1008" /f

schtasks /create /tn "UGC Update" /tr "\"%PROGRAMFILES%\UngoogledChromium\chrlauncher.exe\"" /ru "SYSTEM" /sc ONLOGON /delay "0000:30" /it /rl HIGHEST /f > NUL
PowerShell -NoP -C "$TaskSet = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Set-ScheduledTask -TaskName 'UGC Update' -Settings $TaskSet" > NUL

for /f "usebackq delims=" %%A in (`dir /b /a:d "%SYSTEMDRIVE%\Users" ^| findstr /v /i /x /c:"Public" /c:"Default User" /c:"All Users"`) do (
	echo 	PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%PUBLIC%\Desktop\Chromium.lnk'); $S.TargetPath = '%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe'; $S.Arguments = '--flag-switches-begin --no-default-browser-check --extension-mime-request-handling=always-prompt-for-install --flag-switches-end'; $S.WorkingDirectory = '%PROGRAMFILES%\UngoogledChromium\bin'; $S.IconLocation = '%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe, 0'; $S.Save()"
	PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%PUBLIC%\Desktop\Chromium.lnk'); $S.TargetPath = '%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe'; $S.Arguments = '--flag-switches-begin --no-default-browser-check --extension-mime-request-handling=always-prompt-for-install --flag-switches-end'; $S.WorkingDirectory = '%PROGRAMFILES%\UngoogledChromium\bin'; $S.IconLocation = '%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe, 0'; $S.Save()"

	mkdir "%SYSTEMDRIVE%\Users\%%A\AppData\Roaming\OpenShell\Pinned"
	copy /y "%PUBLIC%\Desktop\Chromium.lnk" "%SYSTEMDRIVE%\Users\%%A\AppData\Roaming\OpenShell\Pinned"
)

PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Chromium.lnk'); $S.TargetPath = '%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe'; $S.Arguments = '--flag-switches-begin --no-default-browser-check --extension-mime-request-handling=always-prompt-for-install --flag-switches-end'; $S.WorkingDirectory = '%PROGRAMFILES%\UngoogledChromium\bin'; $S.IconLocation = '%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe, 0'; $S.Save()"

for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
	reg query "HKU\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
		if not errorlevel 1 (
			if "%%A"=="AME_UserHive_Default" (
				call :AFISCALL "%SYSTEMDRIVE%\Users\Default\AppData\Roaming" "%%A"
			) else (
				for /f "usebackq tokens=2* delims= " %%B in (`reg query "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "AppData" 2^>^&1 ^| findstr /R /X /C:".*AppData[ ]*REG_SZ[ ].*"`) do (
					call :AFISCALL "%%C" "%%A"
				)
			)
	)
)

copy /y AssociationsUGC.dll "%SYSTEMROOT%\System32\OEMDefaultAssociations.dll"

exit /b 0

:AFISCALL

setlocal

if not "%~2"=="AME_UserHive_Default" (
	del "%~1\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Chromium.lnk" /q /f
	mkdir "%~1\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
	PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%~1\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Chromium.lnk'); $S.TargetPath = '%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe'; $S.Arguments = '--flag-switches-begin --no-default-browser-check --extension-mime-request-handling=always-prompt-for-install --flag-switches-end'; $S.IconLocation = '%PROGRAMFILES%\UngoogledChromium\bin\chrome.exe, 0'; $S.Save()"

	reg add "HKU\%~2\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v "Favorites" /t REG_BINARY /d "00a40100003a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000001a1e97454eefd801757130704eefd8015eb737704eefd801140056003100000000006355693411005461736b42617200400009000400efbe63556934635569342e0000009d8a0100000001000000000000000000000000000000a29f33005400610073006b00420061007200000016001201320097010000a754662a200046494c4545587e312e4c4e4b00007c0009000400efbe63556934635569342e0000009e8a0100000001000000000000000000520000000000a413a200460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00120000002b00efbe22283a704eefd8011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c00260000001e00efbe0200530079007300740065006d00500069006e006e006500640000001c00000000780300003a001f49471a0359723fa74489c55595fe6b30ee260001002600efbe10000000ce57fdd54defd8016b5d16a0300dda016d49df38310dda011400820074001c004346534616003100000000006355e033120041707044617461000000741a595e96dfd3488d671733bcee28bac5cdfadf9f6756418947c5c76bc0b67f400009000400efbe6355e0336257620b2e00000014070000000002000000000000000000000000000000c013870041007000700044006100740061000000420056003100000000006257b3101000526f616d696e6700400009000400efbe6355e0336257b3102e0000001907000000000200000000000000000000000000000045848a0052006f0061006d0069006e006700000016005c0031000000000093565c2714004d4943524f537e310000440009000400efbe6355e0336257640b2e0000001a0700000000020000000000000000000000000000008d3e04014d006900630072006f0073006f0066007400000018006c00310000000000635544341000494e5445524e7e310000540009000400efbe6355e0336257a20b2e0000002a070000000002000000000000000000000000000000f9f4e30049006e007400650072006e006500740020004500780070006c006f00720065007200000018006200310000000000635545341100515549434b4c7e3100004a0009000400efbe6355e0336257a20b2e0000002b070000000002000000000000000000000000000000db7ee80051007500690063006b0020004c00610075006e00630068000000180060003100000000006355693412005553455250497e310000480009000400efbe635544346257780c2e000000a68701000000020000000000000000000000000000008be53a0055007300650072002000500069006e006e00650064000000180056003100000000000000000010005461736b42617200400009000400efbe00000000000000002e00000000000000000000000000000000000000000000000000000000005400610073006b0042006100720000001600840032003209000062570e1120004368726f6d69756d2e6c6e6b00004a0009000400efbe62575b1062570e112e000000467a00000000080000000000000000000000000000005f89ee004300680072006f006d00690075006d002e006c006e006b0000001c001e0000001d00efbe02004300680072006f006d00690075006d0000001c000000ff" /f
	reg add "HKU\%~2\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v "FavoritesResolve" /t REG_BINARY /d "330300004c0000000114020000000000c0000000000000468300800020000000e7e332704eefd80122283a704eefd8015cf4e1fbd161d801970100000000000001000000000000000000000000000000a0013a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000001a1e97454eefd801757130704eefd8015eb737704eefd801140056003100000000006355693411005461736b42617200400009000400efbe63556934635569342e0000009d8a0100000001000000000000000000000000000000a29f33005400610073006b00420061007200000016000e01320097010000a754662a200046494c4545587e312e4c4e4b00007c0009000400efbe63556934635569342e0000009e8a0100000001000000000000000000520000000000a413a200460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00220000001e00efbe02005500730065007200500069006e006e006500640000001c00120000002b00efbe22283a704eefd8011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c0000009c0000001c000000010000001c0000002d000000000000009b000000110000000300000013ebc8041000000000433a5c55736572735c4d634e696e5c417070446174615c526f616d696e675c4d6963726f736f66745c496e7465726e6574204578706c6f7265725c517569636b204c61756e63685c557365722050696e6e65645c5461736b4261725c46696c65204578706c6f7265722e6c6e6b000060000000030000a058000000000000006465736b746f702d666a63716f626d00a84d9f7c73d4f344bf15faa23dfd8b4733f18e66405bed11aa54000c29341e2ea84d9f7c73d4f344bf15faa23dfd8b4733f18e66405bed11aa54000c29341e2e45000000090000a03900000031535053b1166d44ad8d7048a748402ea43d788c1d0000006800000000480000009b7b87bf89df6547b6a80dc335f1c9bf000000000000000000000000060500004c0000000114020000000000c00000000000004683008000200000006d6c53b0300dda01ed0c2d77310dda01a1ac2577310dda0132090000000000000100000000000000000000000000000078033a001f49471a0359723fa74489c55595fe6b30ee260001002600efbe10000000ce57fdd54defd8016b5d16a0300dda016d49df38310dda011400820074001c004346534616003100000000006355e033120041707044617461000000741a595e96dfd3488d671733bcee28bac5cdfadf9f6756418947c5c76bc0b67f400009000400efbe6355e0336257620b2e00000014070000000002000000000000000000000000000000c013870041007000700044006100740061000000420056003100000000006257b3101000526f616d696e6700400009000400efbe6355e0336257b3102e0000001907000000000200000000000000000000000000000045848a0052006f0061006d0069006e006700000016005c0031000000000093565c2714004d4943524f537e310000440009000400efbe6355e0336257640b2e0000001a0700000000020000000000000000000000000000008d3e04014d006900630072006f0073006f0066007400000018006c00310000000000635544341000494e5445524e7e310000540009000400efbe6355e0336257a20b2e0000002a070000000002000000000000000000000000000000f9f4e30049006e007400650072006e006500740020004500780070006c006f00720065007200000018006200310000000000635545341100515549434b4c7e3100004a0009000400efbe6355e0336257a20b2e0000002b070000000002000000000000000000000000000000db7ee80051007500690063006b0020004c00610075006e00630068000000180060003100000000006355693412005553455250497e310000480009000400efbe635544346257780c2e000000a68701000000020000000000000000000000000000008be53a0055007300650072002000500069006e006e00650064000000180056003100000000000000000010005461736b42617200400009000400efbe00000000000000002e00000000000000000000000000000000000000000000000000000000005400610073006b0042006100720000001600840032003209000062570e1120004368726f6d69756d2e6c6e6b00004a0009000400efbe62575b1062570e112e000000467a00000000080000000000000000000000000000005f89ee004300680072006f006d00690075006d002e006c006e006b0000001c001e0000001d00efbe02004300680072006f006d00690075006d0000001c000000970000001c000000010000001c0000002d0000000000000096000000110000000300000013ebc8041000000000433a5c55736572735c4d634e696e5c417070446174615c526f616d696e675c4d6963726f736f66745c496e7465726e6574204578706c6f7265725c517569636b204c61756e63685c557365722050696e6e65645c5461736b4261725c4368726f6d69756d2e6c6e6b000060000000030000a058000000000000006465736b746f702d666a63716f626d00a84d9f7c73d4f344bf15faa23dfd8b476a5169c1e978ee11aa63000c290b7f7ca84d9f7c73d4f344bf15faa23dfd8b476a5169c1e978ee11aa63000c290b7f7c45000000090000a03900000031535053b1166d44ad8d7048a748402ea43d788c1d0000006800000000480000009b7b87bf89df6547b6a80dc335f1c9bf000000000000000000000000" /f
)